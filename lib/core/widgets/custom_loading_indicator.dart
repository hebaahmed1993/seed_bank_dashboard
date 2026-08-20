import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool isCentered;

  const CustomLoadingIndicator({
    super.key,
    this.size = 28.0,
    this.color,
    this.strokeWidth = 3.0,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    // 🎯 استخدام لون الثيم الأساسي كقيمة افتراضية
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;

    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
      ),
    );

    if (isCentered) {
      return Center(child: indicator);
    }
    return indicator;
  }
}