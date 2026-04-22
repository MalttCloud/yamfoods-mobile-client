import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_loading_providers.g.dart';

@riverpod
class OrderCreationLoading extends _$OrderCreationLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

