import 'package:flutter/cupertino.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.21, -0.98),
          end: Alignment(-0.21, 0.98),
          colors: [Color(0xFF8A9D80), Color(0xFFCDC3BC), Color(0xFFE1B1A6)],
        ),
      ),
      child: child,
    );
  }
}
