import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Enter the code sent to ${widget.phoneNumber}'),
            const SizedBox(height: 24),
            CustomTextField(
              hintText: 'OTP Code',
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  context.go('/home');
                }
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: AppStrings.verify,
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    context.read<AuthCubit>().verifyOtp(widget.phoneNumber, _otpController.text);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
