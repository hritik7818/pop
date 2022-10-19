import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  const CustomText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
