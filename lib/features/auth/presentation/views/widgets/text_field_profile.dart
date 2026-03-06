import 'package:flutter/material.dart';

class TextFieldProfile extends StatelessWidget {
  const TextFieldProfile(
      {super.key, required this.labelText, required this.controller});

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          label: Text(
            labelText,
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
        ));
  }
}