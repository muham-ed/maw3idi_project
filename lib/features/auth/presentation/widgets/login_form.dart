import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v!.contains('@') ? null : 'Invalid email',
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) => v!.length >= 6 ? null : 'Too short',
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthCubit>().login(
                  _emailController.text,
                  _passwordController.text,
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}