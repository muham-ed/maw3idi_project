import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BlocProvider(create: (context) => sl<HomeCubit>(), child: const HomeScreen()),
    const CartScreen(), // CartCubit is provided globally in main.dart
    BlocProvider(create: (context) => sl<ProfileCubit>(), child: const ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
