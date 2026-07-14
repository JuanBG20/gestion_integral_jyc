import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ItemsCardLayout extends StatelessWidget {
  final int itemCount;
  final String itemsSubtitle;
  final IndexedWidgetBuilder itemBuilder;

  const ItemsCardLayout({
    super.key,
    required this.itemCount,
    required this.itemsSubtitle,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Ítems", style: context.textTheme.titleMedium),

              Text(itemsSubtitle, style: context.textTheme.bodySmall),
            ],
          ),

          Divider(color: AppColors.outline),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: itemBuilder,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: itemCount,
          ),
        ],
      ),
    );
  }
}
