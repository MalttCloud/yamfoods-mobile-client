import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/address.dart';
import '../../../../core/errors/failure.dart';

part 'address_events.g.dart';

sealed class AddressUiEvent {}

class AddressCreated extends AddressUiEvent {
  final Address entity;
  final String message;
  AddressCreated(this.entity, this.message);
}

class AddressUpdated extends AddressUiEvent {
  final Address entity;
  final String message;
  AddressUpdated(this.entity, this.message);
}

class AddressDeleted extends AddressUiEvent {
  final int id;
  final String message;
  AddressDeleted(this.id, this.message);
}

class AddressFailure extends AddressUiEvent {
  final Failure failure;
  AddressFailure(this.failure);
}

@riverpod
class AddressUiEvents extends _$AddressUiEvents {
  @override
  AddressUiEvent? build() {
    return null;
  }

  void emit(AddressUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
