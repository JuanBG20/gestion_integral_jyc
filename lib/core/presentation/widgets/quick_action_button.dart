import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label)],
      ),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.onBackground,
        size: 16,
      ),
      iconAlignment: IconAlignment.end,
    );
  }
}
