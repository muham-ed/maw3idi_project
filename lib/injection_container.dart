import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_products_usecase.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

// Note: In a real app, CartRepositoryImpl and DataSource would be here too.
// For brevity, we might use a mock or implement it later.

import 'features/order/data/datasources/order_remote_datasource.dart';
import 'features/order/data/repositories/order_repository_impl.dart';
import 'features/order/domain/repositories/order_repository.dart';
import 'features/order/domain/usecases/create_order_usecase.dart';
import 'features/order/domain/usecases/track_order_usecase.dart';
import 'features/order/domain/usecases/get_order_history_usecase.dart';
import 'features/order/presentation/cubit/order_cubit.dart';

import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';

import 'features/driver/data/datasources/driver_remote_datasource.dart';
import 'features/driver/data/repositories/driver_repository_impl.dart';
import 'features/driver/domain/repositories/driver_repository.dart';
import 'features/driver/domain/usecases/accept_order_usecase.dart';
import 'features/driver/domain/usecases/update_location_usecase.dart';
import 'features/driver/domain/usecases/update_status_usecase.dart';
import 'features/driver/domain/usecases/get_available_orders_usecase.dart';
import 'features/driver/presentation/cubit/driver_cubit.dart';

import 'core/services/socket_service.dart';
import 'core/services/payment_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/otp_service.dart';
import 'core/network/dio_client.dart';
import 'features/admin_dashboard/presentation/cubit/admin_dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Network Client
  const String baseUrl = 'http://192.168.1.5:3000/api/v1/';
  final dioClient = DioClient(baseUrl: baseUrl);
  sl.registerLazySingleton(() => dioClient.dio);

  // Services
  final socketService = SocketService();
  await socketService.init();
  sl.registerLazySingleton(() => socketService);

  final notificationService = NotificationService();
  await notificationService.initialize();
  sl.registerLazySingleton(() => notificationService);

  sl.registerLazySingleton(() => PaymentService(sl()));
  sl.registerLazySingleton(() => OtpService(sl()));
  // ...
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        verifyOtpUseCase: sl(),
        sendOtpUseCase: sl(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));

  // Features - Home
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSource(sl()));

  // Features - Cart
  sl.registerFactory(() => CartCubit(sl(), sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());

  // Features - Order
  sl.registerFactory(() => OrderCubit(
        createOrderUseCase: sl(),
        trackOrderUseCase: sl(),
        getOrderHistoryUseCase: sl(),
      ));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => TrackOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderHistoryUseCase(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSource(sl()));

  // Features - Profile
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  // Features - Driver
  sl.registerFactory(() => DriverCubit(
        acceptOrderUseCase: sl(),
        updateLocationUseCase: sl(),
        updateStatusUseCase: sl(),
        getAvailableOrdersUseCase: sl(),
        socketService: sl(),
      ));
  sl.registerLazySingleton(() => AcceptOrderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLocationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableOrdersUseCase(sl()));
  sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<DriverRemoteDataSource>(() => DriverRemoteDataSource(sl()));

  // Features - Admin Dashboard
  sl.registerFactory(() => AdminDashboardCubit(sl()));

  // External
  // ملاحظة: إذا كنت تستخدم محاكي أندرويد، استبدل IP الخاص بجهازك بـ 10.0.2.2 إذا كان السيرفر يعمل على نفس الجهاز.
  const String baseUrl = 'http://192.168.1.5:3000/api/v1/';

  sl.registerLazySingleton(() => DioClient(baseUrl: baseUrl).dio);
}
