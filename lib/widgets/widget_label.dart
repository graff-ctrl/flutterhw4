import 'package:flutter/material.dart';

class WidgetLabel extends StatelessWidget {
  const WidgetLabel({super.key, required this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2
      ),
    );
  }
}