import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class PaginationFooter extends StatelessWidget {
  final String label;
  final int total;
  final int shown;

  final int start;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PaginationFooter({
    super.key,
    required this.total,
    required this.shown,
    required this.label,
    this.start = 0,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final from = total == 0 ? 0 : start + 1;
    final to = start + shown;

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
            "Mostrando $from-$to de $total $label",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onBackground,
            ),
          ),

          Row(
            children: [
              IconButton(
                tooltip: "Anterior",
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: "Siguiente",
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
