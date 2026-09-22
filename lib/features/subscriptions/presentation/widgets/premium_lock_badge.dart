import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class PremiumLockBadge extends StatelessWidget {
  final IconData icon;
  final bool isLocked;
  final Color? color;
  final double size;

  const PremiumLockBadge({
    super.key,
    required this.icon,
    required this.isLocked,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        Icon(icon, color: color, size: size),

        if (isLocked)
          Positioned(
            right: -4,
            top: -4,

            child: Icon(Icons.lock, size: size * 0.5, color: AppColors.primary),
          ),
      ],
    );
  }
}
