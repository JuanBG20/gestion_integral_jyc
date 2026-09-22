import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SummaryCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.width,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: AppColors.outline),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),

        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  Icon(icon, color: iconColor, size: 20),
                ],
              ),

              const SizedBox(height: 16),

              Text(value, style: context.textTheme.titleLarge),

              const SizedBox(height: 16),

              Text(subtitle, style: context.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
