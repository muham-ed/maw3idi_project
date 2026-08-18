import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.register)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(hintText: 'Full Name', controller: _nameController),
            const SizedBox(height: 16),
            CustomTextField(hintText: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.phoneNumber, controller: _phoneController),
            const SizedBox(height: 16),
            CustomTextField(hintText: 'Password', controller: _passwordController, obscureText: true),
            const SizedBox(height: 24),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  context.go('/home');
                }
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: AppStrings.register,
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    final user = UserEntity(
                      id: '',
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      role: 'client',
                    );
                    context.read<AuthCubit>().register(user, _passwordController.text);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
