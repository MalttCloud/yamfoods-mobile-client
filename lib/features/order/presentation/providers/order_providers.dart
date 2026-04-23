import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/order_api_service.dart';
import '../../data/datasources/order_remote_data_source.dart';
import '../../data/datasources/order_remote_data_source_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_all_orders_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/entities/order_payment_query_result.dart';
import '../../domain/entities/query_order_request.dart';
import '../../domain/usecases/query_order_payment_usecase.dart';

part 'order_providers.g.dart';

// ==================== Data Sources ====================

/// Order API service provider
///
/// Provides Retrofit API service for order endpoints.
/// Uses dioClientProvider since order endpoints require authentication.
@riverpod
Future<OrderApiService> orderApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return OrderApiService(dio);
}

/// Order remote data source provider
///
/// Provides implementation for fetching order data from backend.
@riverpod
Future<OrderRemoteDataSource> orderRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(orderApiServiceProvider.future);
  return OrderRemoteDataSourceImpl(apiService);
}

// ==================== Repository ====================

/// Order repository provider
///
/// Provides the main repository for order operations.
@riverpod
Future<OrderRepository> orderRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    orderRemoteDataSourceProvider.future,
  );
  return OrderRepositoryImpl(remoteDataSource);
}

// ==================== UseCase ====================

/// Get all orders usecase provider
///
/// Provides usecase for fetching all orders.
@riverpod
Future<GetAllOrdersUseCase> getAllOrdersUseCase(Ref ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  return GetAllOrdersUseCase(repository);
}

/// Get order detail usecase provider
///
/// Provides usecase for fetching order details.
@riverpod
Future<GetOrderDetailUseCase> getOrderDetailUseCase(Ref ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  return GetOrderDetailUseCase(repository);
}

/// Create order usecase provider
///
/// Provides usecase for creating orders.
@riverpod
Future<CreateOrderUseCase> createOrderUseCase(Ref ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  return CreateOrderUseCase(repository);
}

/// Query order payment usecase provider
///
/// Provides usecase for querying order payment information.
@riverpod
Future<QueryOrderPaymentUseCase> queryOrderPaymentUseCase(Ref ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  return QueryOrderPaymentUseCase(repository);
}

// ==================== Data Providers ====================

/// All orders list provider
///
/// Fetches all orders using the usecase.
/// Returns [AsyncValue<List<Orderr>>] which handles loading, error, and data states.
@riverpod
Future<List<Orderr>> allOrders(Ref ref) async {
  final usecase = await ref.watch(getAllOrdersUseCaseProvider.future);
  final result = await usecase();

  return result.fold((failure) => throw failure, (orders) => orders);
}

/// Order detail provider
///
/// Fetches order detail by orderId using the usecase.
/// Returns [AsyncValue<OrderDetail>] which handles loading, error, and data states.
@riverpod
Future<OrderDetail> orderDetail(Ref ref, int orderId) async {
  final usecase = await ref.watch(getOrderDetailUseCaseProvider.future);
  final result = await usecase(orderId);

  return result.fold((failure) => throw failure, (orderDetail) => orderDetail);
}

/// Order payment status provider
///
/// Fetches payment status for an order using the usecase.
/// Returns [AsyncValue<OrderPaymentQueryResult>] which handles loading, error, and data states.
@riverpod
Future<OrderPaymentQueryResult> queryOrder(
  Ref ref,
  QueryOrderRequest request,
) async {
  final usecase = await ref.watch(queryOrderPaymentUseCaseProvider.future);
  final result = await usecase(request);

  return result.fold((failure) => throw failure, (status) => status);
}
