import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/responsive.dart';

import 'package:uuid/uuid.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../core/enums/order_type.dart';
import '../../../../core/errors/failure.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/services/chapa_payment_service.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/services/telebirr_payment_service.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../../auth/presentation/providers/auth_user_state.dart';
import '../../../branch/presentation/providers/branch_providers.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../../order/domain/entities/order_request_data.dart';
import '../../../order/domain/entities/query_order_request.dart';
import '../../../order/presentation/providers/order_events.dart';
import '../../../order/presentation/providers/order_notifier.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_summary_provider.dart';
import '../widgets/address_section.dart';
import '../widgets/checkout_summary_card.dart';
import '../widgets/delivery_type_section.dart';
import '../widgets/item_section.dart';
import '../widgets/points_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/payment_verification_dialog.dart';
import '../widgets/promo_code_section.dart';
import '../widgets/schedule_section.dart';
import '../widgets/special_instructions_section.dart';

/// Checkout screen for placing orders.
///
/// This screen will handle:
/// - Order summary display
/// - Delivery type selection (pickup/delivery)
/// - Address selection (for delivery)
/// - Promo code application
/// - Points redemption
/// - Order scheduling
/// - Special instructions
/// - Price breakdown
/// - Order placement
///
/// Payment verification (thanks future self):
/// - **Chapa:** Order created → we store orderId/txRef and start Chapa (SDK
///   pushes its own route). When that route pops we get [RouteAware.didPopNext]
///   → show [PaymentVerificationDialog], then clear cart and go to orders.
/// - **Telebirr:** Order created → we store orderId and start Telebirr (opens
///   external app). When user returns to our app we get [WidgetsBindingObserver]
///   lifecycle resumed → show [PaymentVerificationDialog], then clear cart and
///   go to orders. See [checkoutRouteObserver] in app_router for Chapa.
class CheckoutScreen extends ConsumerStatefulWidget {
  final int branchId;
  final List<Cart> carts;

  const CheckoutScreen({
    super.key,
    required this.branchId,
    required this.carts,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen>
    with WidgetsBindingObserver, RouteAware {
  // Shared for both Chapa and Telebirr: when order is created we store these;
  // when user returns (Chapa: didPopNext, Telebirr: app resumed) we show the
  // verification dialog. _pendingPaymentMethod non-null means we're waiting.
  int? _pendingOrderId;
  String?
  _pendingOrderReference; // For query-order API (backend expects orderReference)
  String? _pendingChapaTxnRef; // Chapa only; Telebirr doesn't have/need txnRef
  PaymentMethod? _pendingPaymentMethod;

  @override //This Method is only for Chapa (route pop)
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Subscribe to route observer so we get didPopNext when a route on top of us
    // is popped (e.g. Chapa payment screen). Unsubscribe first to avoid dupes.
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      checkoutRouteObserver.unsubscribe(this);
      checkoutRouteObserver.subscribe(this, route);
    }
  }

  @override //This Method is only for Telebirr (add observer)
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // For Telebirr (add observer)
  }

  @override //This Method is for both Chapa and Telebirr (remove observer and unsubscribe)
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    ); // For Telebirr (remove observer)
    checkoutRouteObserver.unsubscribe(this); // For Chapa (route pop)
    super.dispose();
  }

  /// Telebirr opens the Telebirr app (external), so we detect return via app
  /// lifecycle. When resumed and we were waiting for Telebirr, show the
  /// verification dialog.
  @override //This Method is only for Telebirr (app resume)
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        _pendingPaymentMethod == PaymentMethod.telebirr &&
        _pendingOrderId != null) {
      _showPaymentVerificationDialog();
    }
  }

  /// Called when a route that was pushed on top of checkout screen is popped (e.g. user
  /// returns from Chapa). We then show the verification dialog.
  @override //This Method is only for Chapa (route pop)
  void didPopNext() {
    if (_pendingPaymentMethod == PaymentMethod.chapa &&
        _pendingOrderId != null) {
      _showPaymentVerificationDialog();
    }
  }

  /// Shows the payment verification dialog for the pending payment (Chapa or
  /// Telebirr). Captures and clears pending state, then defers to next frame
  /// so the dialog actually appears. Uses root navigator context for the overlay.
  void _showPaymentVerificationDialog() {
    final orderId = _pendingOrderId!;
    final orderReference = _pendingOrderReference!;
    final method = _pendingPaymentMethod!;
    final txnRef = _pendingChapaTxnRef;
    _pendingOrderId = null;
    _pendingOrderReference = null;
    _pendingChapaTxnRef = null;
    _pendingPaymentMethod = null;
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final dialogContext =
          SnackbarService.rootNavigatorKey.currentContext ?? context;
      if (dialogContext.mounted) {
        PaymentVerificationDialog.show(
          dialogContext,
          request: QueryOrderRequest(
            method: method,
            orderReference: orderReference,
            orderId: orderId,
            txnRef: txnRef,
          ),
          onSuccess: _clearCartAndNavigate,
        );
      }
    });
  }

  /// Creates OrderRequestData from checkout state and summary.
  OrderRequestData _buildOrderRequestData() {
    final checkoutState = ref.read(checkoutProvider(widget.branchId));
    final summary = ref.read(checkoutSummaryProvider(widget.branchId));
    final distanceKm = ref.read(
      checkoutDeliveryDistanceKmProvider(widget.branchId),
    );

    return OrderRequestData(
      branchId: checkoutState.branchId,
      deliveryAddressId:
          checkoutState.orderType.toOrderType() == OrderType.delivery
          ? checkoutState.selectedAddress?.id
          : null,
      orderType: checkoutState.orderType,
      scheduledAt: checkoutState.scheduledAt,
      method: checkoutState.paymentMethod!,
      note: checkoutState.note,
      quantity: summary.quantity,
      subtotal: summary.subtotal,
      vatTotal: summary.vatTotal,
      deliveryFee: summary.deliveryFee,
      discountTotal: summary.discountTotal,
      totalAmount: summary.totalAmount,
      transactionFee: summary.transactionFee > 0
          ? summary.transactionFee
          : null,
      pointUsed: checkoutState.pointUsed,
      pointDiscount: checkoutState.pointDiscount,
      promoCode: checkoutState.promoCode,
      promoCodeDiscount: checkoutState.promoCodeDiscount,
      distanceKm: distanceKm,
      tableNumber: checkoutState.tableNumber,
    );
  }

  /// Handles place order action.
  ///
  /// Pass [context] for Chapa native checkout; must be mounted when called.
  void _handlePlaceOrder(BuildContext context) {
    final orderData = _buildOrderRequestData();
    ref.read(orderProvider.notifier).createOrder(orderData);
  }

  ChapaPaymentParams? chapaPaymentParams(OrderRequestData orderData) {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ref
          .read(snackbarServiceProvider)
          .showError(
            Failure.payment(
              message:
                  'Please complete your profile (email and phone) to use Chapa.',
            ),
          );
      return null;
    }
    final nameParts = user.name.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : user.name;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    return ChapaPaymentParams(
      amount: orderData.totalAmount.toStringAsFixed(2),
      email: user.email,
      phone: user.phone ?? '',
      firstName: firstName,
      lastName: lastName.isNotEmpty ? lastName : firstName,
      txRef: 'yam_${const Uuid().v4()}',
      title: 'Order Payment',
      desc: 'Payment for your order',
      buttonColor: AppColors.primary,
    );
  }

  void _clearCartAndNavigate(int orderId) {
    ref
        .read(cartProvider(widget.branchId).notifier)
        .deleteAllCartItems(shouldShowSnackBar: false);
    if (mounted) {
      context.pushReplacement(RouteName.orderSuccess, extra: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider(widget.branchId));
    final isTablet = context.isTablet;
    // Listen to order events (payment is already handled inside order notifier)
    ref.listen<OrderUiEvent?>(orderUiEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is OrderCreated) {
        ref.read(orderUiEventsProvider.notifier).clear();
        // Store pending order so we can show verification dialog when user
        // returns (Chapa: didPopNext, Telebirr: app resumed).
        if (next.method == PaymentMethod.chapa) {
          final params = chapaPaymentParams(next.orderRequestData);
          if (params != null) {
            _pendingOrderId = next.response.order.id;
            _pendingOrderReference = next.response.order.orderReference;
            _pendingChapaTxnRef = params.txRef;
            _pendingPaymentMethod = PaymentMethod.chapa;
            ref.read(chapaPaymentServiceProvider).startPayment(context, params);
          } else {
            snackbar.showError(
              Failure.payment(
                message:
                    'Something went wrong when we initiate chapa payment, please contact support',
              ),
            );
          }
        } else if (next.method == PaymentMethod.telebirr) {
          if (next.response.receiveCode != null) {
            _pendingOrderId = next.response.order.id;
            _pendingOrderReference = next.response.order.orderReference;
            _pendingPaymentMethod = PaymentMethod.telebirr;
            ref
                .read(telebirrPaymentServiceProvider)
                .startPayment(next.response.receiveCode!);
          } else {
            snackbar.showError(
              Failure.payment(
                message:
                    'Something went wrong when we initiate telebirr payment, please contact support',
              ),
            );
            return;
          }
        }
      } else if (next is OrderFailure) {
        // Order creation failed OR payment failed
        snackbar.showError(next.failure);
        ref.read(orderUiEventsProvider.notifier).clear();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Checkout'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
          child: Column( 
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Section
                      ItemSection(carts: widget.carts),
                      // Delivery Type Section
                      DeliveryTypeSection(branchId: widget.branchId),
                      // Address Section (only shown for delivery)
                      AddressSection(branchId: widget.branchId),
                      // Promo Code and Points sections
                      if (isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PromoCodeSection(branchId: widget.branchId),
                            ),
                            Expanded(
                              child: PointsSection(branchId: widget.branchId),
                            ),
                          ],
                        )
                      else ...[
                        PromoCodeSection(branchId: widget.branchId),
                        PointsSection(branchId: widget.branchId),
                      ],
                      // Schedule and Special Instructions sections
                      if (isTablet &&
                          checkoutState.orderType.toOrderType() == OrderType.pickup)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final appConfig = ref
                                      .watch(appConfigurationProvider)
                                      .value;
                                  final maxDaysAhead =
                                      appConfig?.maxOrderSchedulingDays ?? 7;
                                  final workingHours = ref.watch(
                                    currentBranchWorkingHoursProvider,
                                  );
                                  return ScheduleSection(
                                    branchId: widget.branchId,
                                    workingHourStart:
                                        workingHours?.opening ??
                                        const TimeOfDay(hour: 9, minute: 0),
                                    workingHourEnd:
                                        workingHours?.closing ??
                                        const TimeOfDay(hour: 22, minute: 0),
                                    maxDaysAhead: maxDaysAhead,
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: SpecialInstructionsSection(
                                branchId: widget.branchId,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        // Schedule Order Section, only visible if order type is pickup
                        if (checkoutState.orderType.toOrderType() == OrderType.pickup)
                          Consumer(
                            builder: (context, ref, child) {
                              final appConfig = ref
                                  .watch(appConfigurationProvider)
                                  .value;
                              final maxDaysAhead =
                                  appConfig?.maxOrderSchedulingDays ?? 7;
                              final workingHours = ref.watch(
                                currentBranchWorkingHoursProvider,
                              );
                              return ScheduleSection(
                                branchId: widget.branchId,
                                workingHourStart:
                                    workingHours?.opening ??
                                    const TimeOfDay(hour: 9, minute: 0),
                                workingHourEnd:
                                    workingHours?.closing ??
                                    const TimeOfDay(hour: 22, minute: 0),
                                maxDaysAhead: maxDaysAhead,
                              );
                            },
                          ),
                        // Special Instructions Section
                        SpecialInstructionsSection(branchId: widget.branchId),
                      ],
                      // Payment Method Section
                      PaymentMethodSection(branchId: widget.branchId),
                      // Bottom padding for summary card
                      SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
              ),
              // Fixed summary card at bottom
              CheckoutSummaryCard(
                branchId: widget.branchId,
                onPlaceOrder: () => _handlePlaceOrder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
