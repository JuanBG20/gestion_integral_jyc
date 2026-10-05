import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';

class BreakdownCard extends StatelessWidget {
  final double? width;
  final String title;
  final String? badgeText;
  final Color? badgeColor;

  final String col1Header;
  final String col2Header;
  final String col3Header;

  final int col1Flex;
  final int col2Flex;
  final int col3Flex;

  final List<BreakdownRowItemEntity> items;

  final VoidCallback? onTap;

  const BreakdownCard({
    super.key,
    this.width,
    required this.title,
    this.badgeText,
    this.badgeColor = AppColors.primary,
    required this.col1Header,
    required this.col2Header,
    required this.col3Header,
    this.col1Flex = 5,
    this.col2Flex = 2,
    this.col3Flex = 3,
    required this.items,
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
            mainAxisSize: MainAxisSize.min,

            children: [
              // HEADER: Titulo y Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Text(title, style: context.textTheme.titleSmall),
                  ),

                  if (badgeText != null) ...[
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor?.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Text(
                        badgeText!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // Cabecera
              Row(
                children: [
                  Expanded(
                    flex: col1Flex,
                    child: Text(col1Header, style: context.textTheme.bodySmall),
                  ),

                  Expanded(
                    flex: col2Flex,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),

                      child: Text(
                        col2Header,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: col3Flex,
                    child: Text(
                      col3Header,
                      textAlign: TextAlign.end,
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              const Divider(color: AppColors.outline),

              // Filas
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,

                separatorBuilder: (_, _) =>
                    const Divider(color: AppColors.outline),

                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),

                    child: Row(
                      children: [
                        Expanded(
                          flex: col1Flex,
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                Icon(item.icon, size: 18, color: Colors.black),

                                const SizedBox(width: 8),
                              ],

                              Expanded(
                                child: Text(
                                  item.leadingText,
                                  style: context.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: col2Flex,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),

                            child: Text(
                              item.centerText,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: col3Flex,
                          child: Text(
                            item.trailingText,
                            textAlign: TextAlign.end,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: item.trailingColor ?? Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
