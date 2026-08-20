import 'package:flutter/material.dart';

class CustomEditButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const CustomEditButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.edit_note,
        color: colorScheme.primary,
      ),
      tooltip: tooltip ?? 'تعديل',
      onPressed: onPressed,
    );
  }
}