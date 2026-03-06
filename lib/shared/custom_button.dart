import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app_colors.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.buttonName, this.onPressed, this.width, this.color});
  final String buttonName;
  final void Function()? onPressed;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color ?? AppColors.primaryColor,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        child: CustomText(
          text: buttonName,
          color: Colors.white,
          size: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}