import 'package:flutter/material.dart';

class CustomPrintButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const CustomPrintButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.print_outlined, // أيقونة الطباعة
        color: colorScheme.primary,
      ),
      tooltip: tooltip ?? 'طباعة ',
      onPressed: onPressed,
    );
  }
}