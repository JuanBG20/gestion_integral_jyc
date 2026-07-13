import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class PaginationFooter extends StatelessWidget {
  final String label;
  final int total;
  final int shown;

  const PaginationFooter({
    super.key,
    required this.total,
    required this.shown,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            "Mostrando 1-$shown de $total $label",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onBackground,
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
