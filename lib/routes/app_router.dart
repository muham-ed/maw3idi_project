import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/home/presentation/screens/home_wrapper.dart';
import '../features/cart/presentation/screens/checkout_screen.dart';
import '../features/order/presentation/screens/order_tracking_screen.dart';
import '../features/driver/presentation/screens/driver_home_screen.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/order/presentation/cubit/order_cubit.dart';
import '../features/driver/presentation/cubit/driver_cubit.dart';
import '../features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../features/admin_dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import '../injection_container.dart' as di;

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/admin',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AdminDashboardCubit>(),
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
          child: OtpScreen(phoneNumber: state.extra as String? ?? ''),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeWrapper(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<OrderCubit>(),
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: '/tracking/:orderId',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<OrderCubit>(),
          child: OrderTrackingScreen(orderId: state.pathParameters['orderId'] ?? '0'),
        ),
      ),
      GoRoute(
        path: '/driver',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<DriverCubit>(),
          child: const DriverHomeScreen(),
        ),
      ),
    ],
  );
}
