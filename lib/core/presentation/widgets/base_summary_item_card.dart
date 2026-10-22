import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class BaseSummaryItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String subtotal;

  const BaseSummaryItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium,
                ),

                Text(subtitle, style: context.textTheme.bodySmall),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(subtotal, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
