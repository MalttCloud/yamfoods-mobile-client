import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/app_configuration_api_service.dart';
import '../../data/datasources/app_configuration_remote_data_source.dart';
import '../../data/datasources/app_configuration_remote_data_source_impl.dart';
import '../../data/repositories/app_configuration_repository_impl.dart';
import '../../domain/entities/app_configuration.dart';
import '../../domain/entities/order_type_config.dart';
import '../../domain/repositories/app_configuration_repository.dart';
import '../../domain/usecases/get_app_configuration_usecase.dart';
import '../../domain/usecases/get_order_types_usecase.dart';

part 'app_configuration_providers.g.dart';

@riverpod
AppConfigurationApiService appConfigurationApiService(Ref ref) {
  final dio = ref.watch(baseDioClientProvider);
  return AppConfigurationApiService(dio);
}

@riverpod
AppConfigurationRemoteDataSource appConfigurationRemoteDataSource(Ref ref) {
  final apiService = ref.watch(appConfigurationApiServiceProvider);
  return AppConfigurationRemoteDataSourceImpl(apiService);
}

@riverpod
AppConfigurationRepository appConfigurationRepository(Ref ref) {
  final remoteDataSource = ref.watch(appConfigurationRemoteDataSourceProvider);
  return AppConfigurationRepositoryImpl(remoteDataSource);
}

@riverpod
GetAppConfigurationUsecase getAppConfigurationUsecase(Ref ref) {
  final repository = ref.watch(appConfigurationRepositoryProvider);
  return GetAppConfigurationUsecase(repository);
}

@riverpod
GetOrderTypesUsecase getOrderTypesUsecase(Ref ref) {
  final repository = ref.watch(appConfigurationRepositoryProvider);
  return GetOrderTypesUsecase(repository);
}

@Riverpod(keepAlive: true)
Future<AppConfiguration> appConfiguration(Ref ref) async {
  final usecase = ref.watch(getAppConfigurationUsecaseProvider);
  final result = await usecase();

  return result.fold((failure) => throw failure, (config) => config);
}


@riverpod
Future<List<OrderTypeConfig>> orderTypes(Ref ref) async {
  final usecase = ref.watch(getOrderTypesUsecaseProvider);
  final result = await usecase();

  return result.fold((failure) => throw failure, (types) => types);
}
