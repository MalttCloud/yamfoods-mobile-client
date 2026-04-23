import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../data/datasources/cart_api_service.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/datasources/cart_remote_data_source_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/increase_cart_quantity_usecase.dart';
import '../../domain/usecases/decrease_cart_quantity_usecase.dart';
import '../../domain/usecases/get_all_carts_usecase.dart';
import '../../domain/usecases/delete_cart_item_usecase.dart';
import '../../domain/usecases/delete_all_cart_items_usecase.dart';
import 'cart_notifier.dart';

part 'cart_providers.g.dart';

/// Cart API service provider
///
/// Uses dioClientProvider (with auth interceptor) because all cart endpoints
/// are protected and require authentication:
/// - getAllCarts, addToCart, increaseCartQuantity, decreaseCartQuantity,
///   deleteCartItem, deleteAllCartItems
@riverpod
Future<CartApiService> cartApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return CartApiService(dio);
}

@riverpod
Future<CartRemoteDataSource> cartRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(cartApiServiceProvider.future);
  return CartRemoteDataSourceImpl(apiService);
}

@riverpod
Future<CartRepository> cartRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(cartRemoteDataSourceProvider.future);
  return CartRepositoryImpl(remoteDataSource);
}

@riverpod
Future<AddToCartUsecase> addToCartUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return AddToCartUsecase(repository);
}

@riverpod
Future<IncreaseCartQuantityUsecase> increaseCartQuantityUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return IncreaseCartQuantityUsecase(repository);
}

@riverpod
Future<DecreaseCartQuantityUsecase> decreaseCartQuantityUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return DecreaseCartQuantityUsecase(repository);
}

@riverpod
Future<GetAllCartsUsecase> getAllCartsUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return GetAllCartsUsecase(repository);
}

@riverpod
Future<DeleteCartItemUsecase> deleteCartItemUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return DeleteCartItemUsecase(repository);
}

@riverpod
Future<DeleteAllCartItemsUsecase> deleteAllCartItemsUseCase(Ref ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return DeleteAllCartItemsUsecase(repository);
}

/// Provider that returns the current cart item count for a branch.
///
/// Returns 0 if cart is not loaded yet or empty.
@riverpod
int cartItemCount(Ref ref, int branchId) {
  final cartAsync = ref.watch(cartProvider(branchId));
  return cartAsync.value?.length ?? 0;
}

/// Provider that checks if more items can be added to cart.
///
/// Returns `true` if cart has less than maxCartItems from app configuration,
/// `false` otherwise.
@riverpod
bool canAddToCart(Ref ref, int branchId) {
  final count = ref.watch(cartItemCountProvider(branchId));
  final appConfig = ref.watch(appConfigurationProvider).value;
  if (appConfig == null) return false;
  return count < appConfig.maxCartItems;
}
