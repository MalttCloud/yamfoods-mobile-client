import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yam_foods/core/constants/env.dart';
import 'package:yam_foods/core/network/interceptors/auth_interceptor.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_api_service.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:yam_foods/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yam_foods/features/auth/domain/repositories/auth_repository.dart';
import 'package:yam_foods/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/login_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/logout_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/register_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/request_reset_password_otp_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/save_phone_number_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/validate_otp_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/verify_phone_usecase.dart';
import 'package:yam_foods/features/auth/domain/usecases/refresh_tokens_usecase.dart';
import 'package:yam_foods/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:yam_foods/features/onboarding/data/datasources/onboarding_local_data_source_impl.dart';
import 'package:yam_foods/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:yam_foods/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:yam_foods/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'package:yam_foods/features/onboarding/domain/usecases/is_first_time_usecase.dart';
import 'package:yam_foods/features/onboarding/domain/usecases/set_first_time_usecase.dart';
import '../../features/order/data/datasources/order_api_service.dart';
import '../../features/order/data/datasources/order_remote_data_source.dart';
import '../../features/order/data/datasources/order_remote_data_source_impl.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/get_all_orders_usecase.dart';
import '../../features/order/domain/usecases/get_order_detail_usecase.dart';
import '../../features/order/domain/usecases/get_out_for_delivery_order_usecase.dart';
import '../../features/order/domain/usecases/update_order_status_usecase.dart';
import '../../features/profile/data/datasources/profile_api_service.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import 'retry_interceptor.dart';
import 'logging_interceptor.dart';
import 'package:yam_foods/core/services/socket_service.dart';
import 'package:yam_foods/core/services/location_socket_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Load environment variables FIRST
  locator.registerLazySingleton<EnvConfig>(
    () => EnvConfig(
      baseUrl: 'https://api.yamfoods.com/api', //https://api.yamfoods.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // 2. External libs (synchronous)
  locator.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
    ),
  );
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // 3. Initialize SharedPreferences FIRST and wait for it
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  // 4. Register Dio (without interceptors initially)
  locator.registerLazySingleton<Dio>(() {
    return Dio(
      BaseOptions(
        baseUrl: locator<EnvConfig>().baseUrl,
        connectTimeout: locator<EnvConfig>().connectTimeout,
        receiveTimeout: locator<EnvConfig>().receiveTimeout,
        headers: {'content-type': 'application/json'},
      ),
    );
  });

  // 5. Data sources (that depend on Dio and SharedPreferences)
  locator.registerLazySingleton<AuthApiService>(
    () => AuthApiService(locator<Dio>()),
  );
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<AuthApiService>()),
  );
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      locator<FlutterSecureStorage>(),
      locator<SharedPreferences>(), // Now this is ready!
    ),
  );

  // Socket Service
  locator.registerLazySingleton<SocketService>(
    () => SocketService(locator<Logger>(), locator<EnvConfig>()),
  );

  // Location socket sender service (uses shared socket)
  locator.registerLazySingleton<LocationSocketService>(
    () => LocationSocketService(locator<SocketService>(), locator<Logger>()),
  );

  // 6. Order API services
  locator.registerLazySingleton<OrderApiService>(
    () => OrderApiService(locator<Dio>()),
  );
  locator.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(locator<OrderApiService>()),
  );

  // 7. Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(locator<OrderRemoteDataSource>()),
  );

  // 8. Configure Dio interceptors AFTER repositories are registered
  final dio = locator<Dio>();
  dio.interceptors.addAll([
    AuthInterceptor(
      authRepository: locator<AuthRepository>(),
      localDataSource: locator<AuthLocalDataSource>(),
    ),
    RetryInterceptor(
      dio: dio,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ),
    LoggingInterceptor(),
  ]);

  // Use cases (that depend on repository)
  //Auth
  locator.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<RefreshTokensUsecase>(
    () => RefreshTokensUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<RequestResetPasswordOtpUsecase>(
    () => RequestResetPasswordOtpUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<SavePhoneNumberUsecase>(
    () => SavePhoneNumberUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<ValidateOtpUsecase>(
    () => ValidateOtpUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<VerifyPhoneUsecase>(
    () => VerifyPhoneUsecase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<GetCurrentUserUsecase>(
    () => GetCurrentUserUsecase(locator<AuthRepository>()),
  );

  //Order
  locator.registerLazySingleton<GetAllOrdersUseCase>(
    () => GetAllOrdersUseCase(locator<OrderRepository>()),
  );
  locator.registerLazySingleton<GetOrderDetailUseCase>(
    () => GetOrderDetailUseCase(locator<OrderRepository>()),
  );
  locator.registerLazySingleton<UpdateOrderStatusUseCase>(
    () => UpdateOrderStatusUseCase(locator<OrderRepository>()),
  );
  locator.registerLazySingleton<GetOutForDeliveryOrderUsecase>(
    () => GetOutForDeliveryOrderUsecase(locator<OrderRepository>()),
  );

  // 8. Onboarding
  locator.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(locator<FlutterSecureStorage>()),
  );
  locator.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(locator<OnboardingLocalDataSource>()),
  );
  locator.registerLazySingleton<GetOnboardingPagesUsecase>(
    () => GetOnboardingPagesUsecase(locator<OnboardingRepository>()),
  );
  locator.registerLazySingleton<IsFirstTimeUsecase>(
    () => IsFirstTimeUsecase(locator<OnboardingRepository>()),
  );
  locator.registerLazySingleton<SetFirstTimeUsecase>(
    () => SetFirstTimeUsecase(locator<OnboardingRepository>()),
  );

  // 9. Profile
  locator.registerLazySingleton<ProfileApiService>(
    () => ProfileApiService(locator<Dio>()),
  );
  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(locator<ProfileApiService>()),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: locator<ProfileRemoteDataSource>(),
    ),
  );
  locator.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(locator<ProfileRepository>()),
  );
  locator.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(locator<ProfileRepository>()),
  );
  locator.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(locator<ProfileRepository>()),
  );
}
