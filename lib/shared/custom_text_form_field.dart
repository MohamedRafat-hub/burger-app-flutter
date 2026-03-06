import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hint,
    required this.isPassword,
    this.controller,
  });

  final String hint;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: AppColors.primaryColor,
      validator: (value) {
        if(value == null || value.isEmpty)
          {
            return 'Field is required';
          }
      },
      cursorHeight: 20,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword ? GestureDetector(
          onTap: (){
            setState(() {
              _obscureText = !_obscureText;
            });
          },
            child: _obscureText ? Icon(CupertinoIcons.eye_slash) : Icon(CupertinoIcons.eye)) : null,
        hintText: widget.hint,
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(color: AppColors.primaryColor, fontSize: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
