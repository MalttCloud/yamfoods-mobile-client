import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_loading_providers.g.dart';

@riverpod
class CartOperationLoading extends _$CartOperationLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class CartAddLoading extends _$CartAddLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class CartQuantityUpdateLoading extends _$CartQuantityUpdateLoading {
  @override
  Set<int> build() => {};

  void start(int cartId) {
    state = {...state, cartId};
  }

  void stop(int cartId) {
    state = state.where((e) => e != cartId).toSet();
  }
}

@riverpod
class CartDeleteLoading extends _$CartDeleteLoading {
  @override
  Set<int> build() => {};

  void start(int cartId) {
    state = {...state, cartId};
  }

  void stop(int cartId) {
    state = state.where((e) => e != cartId).toSet();
  }
}

@riverpod
class CartDeleteAllLoading extends _$CartDeleteAllLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}
