import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// Always used inside a [RoundedCard], which already supplies the white
/// filled/bordered/rounded surface — this only needs to render the input
/// itself with no additional decoration.
class AppTextField extends StatelessWidget {
  const AppTextField({super.key, this.hintText, this.obscureText = false, this.controller, this.keyboardType, this.suffixIcon});

  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.container /* ui-text-muted */),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: AppColors.dashboard /* ui-text-primary */),
      cursorColor: AppColors.dashboard,
    );
  }
}
