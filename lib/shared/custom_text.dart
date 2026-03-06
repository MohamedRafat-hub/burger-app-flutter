
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
       this.color,
       this.size,
       this.fontWeight, this.textAlign , this.maxLines});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.linear(1.0),
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
      ),
    );
  }
}
