import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_loading_providers.g.dart';

@riverpod
class AddressCreateLoading extends _$AddressCreateLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class AddressUpdateLoading extends _$AddressUpdateLoading {
  @override
  Set<int> build() => {};

  void start(int id) {
    state = {...state, id};
  }

  void stop(int id) {
    state = state.where((e) => e != id).toSet();
  }
}

@riverpod
class AddressDeleteLoading extends _$AddressDeleteLoading {
  @override
  Set<int> build() => {};

  void start(int id) {
    state = {...state, id};
  }

  void stop(int id) {
    state = state.where((e) => e != id).toSet();
  }
}
