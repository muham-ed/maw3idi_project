import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await di.init();
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Initialization Error: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => di.sl<CartCubit>(),
          child: MaterialApp.router(
            title: 'Maw3idi',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
