this is example for features which matters their state have crud operation
ignor the search functionality from here
bank_events.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bank.dart';
import '../../../../core/errors/failure.dart';

part 'bank_events.g.dart';

sealed class BankUiEvent {}

class BankCreated extends BankUiEvent {
  final BankEntity entity;
  final String message;
  BankCreated(this.entity, this.message);
}

class BankUpdated extends BankUiEvent {
  final BankEntity entity;
  final String message;
  BankUpdated(this.entity, this.message);
}

class BankDeleted extends BankUiEvent {
  final int id;
  final String message;
  BankDeleted(this.id, this.message);
}

class BankFailure extends BankUiEvent {
  final Failure failure;
  BankFailure(this.failure);
}

@riverpod
class BankUiEvents extends _$BankUiEvents {
  @override
  BankUiEvent? build() {
    return null;
  }

  void emit(BankUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}


bank_loading_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bank_loading_providers.g.dart';

@riverpod
class BankCreateLoading extends _$BankCreateLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class BankUpdateLoading extends _$BankUpdateLoading {
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
class BankDeleteLoading extends _$BankDeleteLoading {
  @override
  Set<int> build() => {};

  void start(int id) {
    state = {...state, id};
  }

  void stop(int id) {
    state = state.where((e) => e != id).toSet();
  }
}

bank_notifier.dart, ignore the search from here
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bank.dart';
import 'bank_providers.dart';
import 'bank_events.dart';
import 'bank_loading_providers.dart';

part 'bank_notifier.g.dart';

@riverpod
class BankNotifier extends _$BankNotifier {
  @override
  Future<List<BankEntity>> build() async {
    return await _load();
  }

  // Search query state
  String? _currentSearch;

  Future<void> load() async {
    _currentSearch = null; // Reset search when manually loading
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load());
  }

  /// Search banks
  Future<void> search(String query) async {
    _currentSearch = query.trim().isEmpty ? null : query.trim();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(search: _currentSearch));
  }

  Future<void> create({
    required String name,
  }) async {
    final createLoading = ref.read(bankCreateLoadingProvider.notifier);
    createLoading.setLoading(true);

    final useCase = ref.read(createBankUseCaseProvider);
    final result = await useCase.call(
      name: name,
    );

    result.fold(
      (failure) {
        ref.read(bankUiEventsProvider.notifier).emit(BankFailure(failure));
      },
      (created) {
        final current = state.value ?? const <BankEntity>[];
        state = AsyncValue.data([created, ...current]);
        ref.read(bankUiEventsProvider.notifier).emit(
          BankCreated(created, 'Bank created successfully'),
        );
      },
    );

    createLoading.setLoading(false);
  }

  Future<void> updateBank({
    required int id,
    required String name,
  }) async {
    final updating = ref.read(bankUpdateLoadingProvider.notifier);
    updating.start(id);
    final useCase = ref.read(updateBankUseCaseProvider);
    final result = await useCase.call(
      id: id,
      name: name,
    );

    result.fold(
      (failure) {
        ref.read(bankUiEventsProvider.notifier).emit(BankFailure(failure));
      },
      (updated) {
        final list = List<BankEntity>.from(state.value ?? const <BankEntity>[]);
        final idx = list.indexWhere((e) => e.id == id);
        if (idx != -1) list[idx] = updated;
        state = AsyncValue.data(list);
        ref.read(bankUiEventsProvider.notifier).emit(
          BankUpdated(updated, 'Bank updated successfully'),
        );
      },
    );

    updating.stop(id);
  }

  Future<void> delete({
    required int id,
  }) async {
    final deleting = ref.read(bankDeleteLoadingProvider.notifier);
    deleting.start(id);

    final useCase = ref.read(deleteBankUseCaseProvider);
    final result = await useCase.call(id: id);

    result.fold(
      (failure) {
        ref.read(bankUiEventsProvider.notifier).emit(BankFailure(failure));
      },
      (deletedEntity) {
        final list = List<BankEntity>.from(state.value ?? const <BankEntity>[]);
        list.removeWhere((e) => e.id == id);
        state = AsyncValue.data(list);
        ref.read(bankUiEventsProvider.notifier).emit(
          BankDeleted(id, 'Bank deleted successfully'),
        );
      },
    );

    deleting.stop(id);
  }

  Future<List<BankEntity>> _load({
    String? search,
  }) async {
    final useCase = ref.read(getBanksUseCaseProvider);
    final result = await useCase.call(search: search);
    return result.fold(
      (failure) {
        throw failure;
      },
      (items) => items,
    );
  }
}

bank_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/bank_api_service.dart';
import '../../data/datasources/bank_remote_data_source.dart';
import '../../data/datasources/bank_remote_data_source_impl.dart';
import '../../data/repositories/bank_repository_impl.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/usecases/get_banks_usecase.dart';
import '../../domain/usecases/create_bank_usecase.dart';
import '../../domain/usecases/update_bank_usecase.dart';
import '../../domain/usecases/delete_bank_usecase.dart';

part 'bank_providers.g.dart';

@riverpod
BankApiService bankApiService(Ref ref) {
  return const BankApiService();
}

@riverpod
BankRemoteDataSource bankRemoteDataSource(Ref ref) {
  return BankRemoteDataSourceImpl(
    ref.watch(bankApiServiceProvider),
  );
}

@riverpod
BankRepository bankRepository(Ref ref) {
  return BankRepositoryImpl(
    ref.watch(bankRemoteDataSourceProvider),
  );
}

@riverpod
GetBanksUseCase getBanksUseCase(Ref ref) {
  return GetBanksUseCase(
    ref.watch(bankRepositoryProvider),
  );
}

@riverpod
CreateBankUseCase createBankUseCase(Ref ref) {
  return CreateBankUseCase(
    ref.watch(bankRepositoryProvider),
  );
}

@riverpod
UpdateBankUseCase updateBankUseCase(Ref ref) {
  return UpdateBankUseCase(
    ref.watch(bankRepositoryProvider),
  );
}

@riverpod
DeleteBankUseCase deleteBankUseCase(Ref ref) {
  return DeleteBankUseCase(
    ref.watch(bankRepositoryProvider),
  );
}
