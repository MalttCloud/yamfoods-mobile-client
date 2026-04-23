import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failure.dart';

part 'cart_events.g.dart';

sealed class CartUiEvent {}

class CartItemAdded extends CartUiEvent {
  final String message;
  CartItemAdded(this.message);
}

class CartQuantityIncreased extends CartUiEvent {
  final int cartId;
  final String message;
  CartQuantityIncreased(this.cartId, this.message);
}

class CartQuantityDecreased extends CartUiEvent {
  final int cartId;
  final String message;
  CartQuantityDecreased(this.cartId, this.message);
}

class CartItemDeleted extends CartUiEvent {
  final int cartId;
  final String message;
  CartItemDeleted(this.cartId, this.message);
}

class AllCartItemsDeleted extends CartUiEvent {
  final String message;
  AllCartItemsDeleted(this.message);
}

class CartFailure extends CartUiEvent {
  final Failure failure;
  CartFailure(this.failure);
}

@riverpod
class CartUiEvents extends _$CartUiEvents {
  @override
  CartUiEvent? build() {
    return null;
  }

  void emit(CartUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
