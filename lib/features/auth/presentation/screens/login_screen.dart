import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.welcome,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: const Icon(Icons.language),
                      onPressed: () {
                        setState(() {
                          AppStrings.isArabic = !AppStrings.isArabic;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                    if (state is AuthOtpSent) {
                      context.push('/otp', extra: state.phoneNumber);
                    }
                  },
                  builder: (context, state) {
                    return AuthForm(
                      phoneController: _phoneController,
                      buttonText: AppStrings.sendOTP,
                      isLoading: state is AuthLoading,
                      onAction: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthCubit>().sendOtp(_phoneController.text);
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
                TextButton(
                  onPressed: () => context.push('/admin'),
                  child: const Text('Admin Dashboard (Dev Access)', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => context.push('/driver'),
                  child: const Text('Driver Dashboard (Dev Access)', style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
