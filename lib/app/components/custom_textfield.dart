import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';


class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputType,
    this.prefixText,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: AppSizes.iconSize)
              : null,
          prefixText: prefixText,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.background,
          labelStyle: TextStyle(
            fontSize: AppSizes.lg,
            color: AppColors.primary,
          ),
        ),
        style: TextStyle(fontSize: AppSizes.lg),
      ),
    );
  }
}
