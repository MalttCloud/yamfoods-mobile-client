import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_loading_providers.g.dart';

@riverpod
class ReviewCreateLoading extends _$ReviewCreateLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class ReviewUpdateLoading extends _$ReviewUpdateLoading {
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
class ReviewDeleteLoading extends _$ReviewDeleteLoading {
  @override
  Set<int> build() => {};

  void start(int id) {
    state = {...state, id};
  }

  void stop(int id) {
    state = state.where((e) => e != id).toSet();
  }
}
