import '../../cart/domain/entities/cart.dart';

/// Arguments passed to checkout screen.
///
/// Contains the branch ID and list of cart items.
class CheckoutArgs {
  final int branchId;
  final List<Cart> carts;

  const CheckoutArgs({required this.branchId, required this.carts});
}
