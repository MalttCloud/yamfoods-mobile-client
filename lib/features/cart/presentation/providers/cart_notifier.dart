import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_user_state.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_request_data.dart';
import 'cart_events.dart';
import 'cart_loading_providers.dart';
import 'cart_providers.dart';

part 'cart_notifier.g.dart';

/// Manages cart list state and CRUD operations for a specific branch.
///
/// **State Management:**
/// - Optimistically updates local state on success
/// - Emits UI events for success/failure
/// - Tracks loading states per operation
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  Future<List<Cart>> build(int branchId) async {
    // Cart APIs require auth, but home product cards watch this provider for
    // guests too. Skip the network call here so AuthInterceptor doesn't cancel
    // the request and flood the console with "Not authenticated" errors.
    // Watching auth also reloads the cart after login and clears it on logout.
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    if (!isAuthenticated) {
      return const [];
    }
    return await _load(branchId);
  }

  Future<void> load(int branchId) async {
    // Same guard as [build] for explicit reloads (e.g. cart screen retry).
    if (!ref.read(isAuthenticatedProvider)) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(branchId));
  }

  /// Adds an item to the cart. Optimistic when [productForOptimistic] is
  /// provided: updates UI immediately and restores state on API failure.
  Future<void> addToCart(
    CartRequestData data, {
    Product? productForOptimistic,
  }) async {
    final addLoading = ref.read(cartAddLoadingProvider.notifier);
    final operationLoading = ref.read(cartOperationLoadingProvider.notifier);
    operationLoading.setLoading(true);
    addLoading.setLoading(true);

    try {
      // Save current state as reserve before optimistic update
      final current = state.value ?? const <Cart>[];
      final reserveState = List<Cart>.from(current);

      // Optimistic update: append new item locally when product is provided
      if (productForOptimistic != null) {
        final now = DateTime.now();
        const tempId = -1;
        final tempCart = Cart(
          id: tempId,
          userId: 0,
          productId: data.productId,
          quantity: data.quantity,
          createdAt: now,
          updatedAt: now,
          product: productForOptimistic,
        );
        final list = List<Cart>.from(current)..add(tempCart);
        state = AsyncValue.data(list);
      }

      final useCase = await ref.read(addToCartUseCaseProvider.future);
      final result = await useCase.call(data);

      result.fold(
        (failure) {
          if (productForOptimistic != null) {
            state = AsyncValue.data(reserveState);
          }
          ref.read(cartUiEventsProvider.notifier).emit(CartFailure(failure));
        },
        (_) {
          // Reload carts to get the latest state (real ids from server)
          load(branchId);
          ref
              .read(cartUiEventsProvider.notifier)
              .emit(CartItemAdded('Item added to cart successfully'));
        },
      );
    } finally {
      operationLoading.setLoading(false);
      addLoading.setLoading(false);
    }
  }

  Future<void> increaseQuantity(int cartId) async {
    final updating = ref.read(cartQuantityUpdateLoadingProvider.notifier);
    final operationLoading = ref.read(cartOperationLoadingProvider.notifier);
    updating.start(cartId);
    operationLoading.setLoading(true);

    try {
      // Save current state as reserve before optimistic update
      final current = state.value ?? const <Cart>[];
      final reserveState = List<Cart>.from(current);

      // Optimistic update: increase quantity locally
      final list = List<Cart>.from(current);
      final idx = list.indexWhere((c) => c.id == cartId);
      if (idx != -1) {
        final cart = list[idx];
        list[idx] = cart.copyWith(quantity: cart.quantity + 1);
        state = AsyncValue.data(list);

        // Get productId from cart to call API
        final productId = cart.productId;
        final useCase = await ref.read(
          increaseCartQuantityUseCaseProvider.future,
        );
        final result = await useCase.call(productId);

        result.fold(
          (failure) {
            // Restore from reserve on failure (no load() call to preserve state)
            state = AsyncValue.data(reserveState);
            ref.read(cartUiEventsProvider.notifier).emit(CartFailure(failure));
          },
          (_) {
            ref
                .read(cartUiEventsProvider.notifier)
                .emit(CartQuantityIncreased(cartId, 'Quantity increased'));
          },
        );
      }
    } finally {
      updating.stop(cartId);
      operationLoading.setLoading(false);
    }
  }

  Future<void> decreaseQuantity(int cartId) async {
    final updating = ref.read(cartQuantityUpdateLoadingProvider.notifier);
    final operationLoading = ref.read(cartOperationLoadingProvider.notifier);
    updating.start(cartId);
    operationLoading.setLoading(true);

    try {
      // Save current state as reserve before optimistic update
      final current = state.value ?? const <Cart>[];
      final reserveState = List<Cart>.from(current);

      // Optimistic update: decrease quantity locally
      final list = List<Cart>.from(current);
      final idx = list.indexWhere((c) => c.id == cartId);
      if (idx != -1) {
        final cart = list[idx];
        final newQuantity = cart.quantity > 1
            ? cart.quantity - 1
            : cart.quantity;
        list[idx] = cart.copyWith(quantity: newQuantity);
        state = AsyncValue.data(list);

        // Get productId from cart to call API
        final productId = cart.productId;
        final useCase = await ref.read(
          decreaseCartQuantityUseCaseProvider.future,
        );
        final result = await useCase.call(productId);

        result.fold(
          (failure) {
            // Restore from reserve on failure (no load() call to preserve state)
            state = AsyncValue.data(reserveState);
            ref.read(cartUiEventsProvider.notifier).emit(CartFailure(failure));
          },
          (_) {
            ref
                .read(cartUiEventsProvider.notifier)
                .emit(CartQuantityDecreased(cartId, 'Quantity decreased'));
          },
        );
      }
    } finally {
      updating.stop(cartId);
      operationLoading.setLoading(false);
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    final deleting = ref.read(cartDeleteLoadingProvider.notifier);
    deleting.start(cartId);

    try {
      // Save current state as reserve before optimistic update
      final current = state.value ?? const <Cart>[];
      final reserveState = List<Cart>.from(current);

      // Optimistic update: remove item locally
      final list = List<Cart>.from(current);
      final cartToDelete = list.firstWhere((c) => c.id == cartId);
      list.removeWhere((c) => c.id == cartId);
      state = AsyncValue.data(list);

      // Get productId from cart to call API
      final productId = cartToDelete.productId;
      final useCase = await ref.read(deleteCartItemUseCaseProvider.future);
      final result = await useCase.call(productId);

      result.fold(
        (failure) {
          // Restore from reserve on failure (no load() call to preserve state)
          state = AsyncValue.data(reserveState);
          ref.read(cartUiEventsProvider.notifier).emit(CartFailure(failure));
        },
        (_) {
          ref
              .read(cartUiEventsProvider.notifier)
              .emit(CartItemDeleted(cartId, 'Item removed from cart'));
        },
      );
    } finally {
      deleting.stop(cartId);
    }
  }

  Future<void> deleteAllCartItems({bool shouldShowSnackBar = true}) async {
    final deleteAllLoading = ref.read(cartDeleteAllLoadingProvider.notifier);
    deleteAllLoading.setLoading(true);

    try {
      // Save current state as reserve before optimistic update
      final current = state.value ?? const <Cart>[];
      final reserveState = List<Cart>.from(current);

      // Optimistic update: clear list locally
      state = const AsyncValue.data([]);

      final useCase = await ref.read(deleteAllCartItemsUseCaseProvider.future);
      final result = await useCase.call();

      result.fold(
        (failure) {
          // Restore from reserve on failure (no load() call to preserve state)
          state = AsyncValue.data(reserveState);
          ref.read(cartUiEventsProvider.notifier).emit(CartFailure(failure));
        },
        (_) {
          if (shouldShowSnackBar) {
            ref
                .read(cartUiEventsProvider.notifier)
                .emit(AllCartItemsDeleted('All items removed from cart'));
          }
        },
      );
    } finally {
      deleteAllLoading.setLoading(false);
    }
  }

  /// Throws [Failure] to be caught by [AsyncValue.guard].
  Future<List<Cart>> _load(int branchId) async {
    final useCase = await ref.read(getAllCartsUseCaseProvider.future);
    final result = await useCase.call(branchId);
    return result.fold((failure) {
      throw failure;
    }, (carts) => carts);
  }
}
