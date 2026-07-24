import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: 'Enter your name',
        hintStyle: const TextStyle(color: Color(0xFF8B7D92)),
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.black,
    );
  }
}
