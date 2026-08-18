import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_strings.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController phoneController;
  final VoidCallback onAction;
  final String buttonText;
  final bool isLoading;

  const AuthForm({
    super.key,
    required this.phoneController,
    required this.onAction,
    required this.buttonText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hintText: AppStrings.phoneNumber,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 24.h),
        CustomButton(
          text: buttonText,
          isLoading: isLoading,
          onPressed: onAction,
        ),
      ],
    );
  }
}
