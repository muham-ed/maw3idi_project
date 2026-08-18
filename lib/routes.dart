import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'injection_container.dart' as di;

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<AuthCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);