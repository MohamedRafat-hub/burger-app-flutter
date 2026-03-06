import 'package:flutter/material.dart';

import '../../../../../shared/custom_text.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({super.key, this.onPressed, required this.buttonName , this.color, this.textColor, this.width});
  final void Function()? onPressed;
  final String buttonName;
  final Color? color;
  final Color? textColor;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      color: color ?? Colors.white,
      minWidth: width ?? double.infinity,
      onPressed: onPressed,
      child: CustomText(
          text: buttonName,
          color: textColor ?? Colors.black,
          size: 20,
          fontWeight: FontWeight.w700),
    );
  }
}
