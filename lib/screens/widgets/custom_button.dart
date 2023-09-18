import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final void Function() onPressed;
  const CustomButton(this.color, this.textColor, this.text, this.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          textStyle: const TextStyle(
            fontSize: 24,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.67,
          ),
          fixedSize: Size(1.sw, 70),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
