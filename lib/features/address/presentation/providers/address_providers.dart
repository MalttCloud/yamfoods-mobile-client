import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/address_api_service.dart';
import '../../data/datasources/address_remote_data_source.dart';
import '../../data/datasources/address_remote_data_source_impl.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/create_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';

part 'address_providers.g.dart';

/// Address API service provider
///
/// Uses dioClientProvider (with auth interceptor) because all address endpoints
/// require authentication.
@riverpod
Future<AddressApiService> addressApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return AddressApiService(dio);
}

@riverpod
Future<AddressRemoteDataSource> addressRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(addressApiServiceProvider.future);
  return AddressRemoteDataSourceImpl(apiService);
}

@riverpod
Future<AddressRepository> addressRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    addressRemoteDataSourceProvider.future,
  );
  return AddressRepositoryImpl(remoteDataSource);
}

@riverpod
Future<GetAddressesUsecase> getAddressesUseCase(Ref ref) async {
  final repository = await ref.watch(addressRepositoryProvider.future);
  return GetAddressesUsecase(repository);
}

@riverpod
Future<CreateAddressUsecase> createAddressUseCase(Ref ref) async {
  final repository = await ref.watch(addressRepositoryProvider.future);
  return CreateAddressUsecase(repository);
}

@riverpod
Future<UpdateAddressUsecase> updateAddressUseCase(Ref ref) async {
  final repository = await ref.watch(addressRepositoryProvider.future);
  return UpdateAddressUsecase(repository);
}

@riverpod
Future<DeleteAddressUsecase> deleteAddressUseCase(Ref ref) async {
  final repository = await ref.watch(addressRepositoryProvider.future);
  return DeleteAddressUsecase(repository);
}
