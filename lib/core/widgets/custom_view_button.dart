import 'package:flutter/material.dart';

class CustomViewButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const CustomViewButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.visibility, // أيقونة العرض القياسية
        color: colorScheme.primary, // استخدمنا نفس تنسيق الألوان لتوحيد التصميم
      ),
      tooltip: tooltip ?? 'عرض التفاصيل',
      onPressed: onPressed,
    );
  }
}