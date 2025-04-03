import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String customText;
  const CustomButton({
    super.key,
    this.onPressed,
    required this.customText,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(onPressed: onPressed, child: Text(customText) ),
    );
  }
}