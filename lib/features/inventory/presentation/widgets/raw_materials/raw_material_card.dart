import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/raw_material_action_handler.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/category_budget.dart';
import 'package:go_router/go_router.dart';

class RawMaterialCard extends ConsumerWidget {
  final RawMaterialEntity rawMaterial;
  final bool isAdmin;

  const RawMaterialCard({
    super.key,
    required this.rawMaterial,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCardShell(
      onTapCard: () =>
          context.go('/inventory/edit-material', extra: rawMaterial),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CategoryBudget(text: rawMaterial.fullCategory),

                  const SizedBox(height: 8),

                  Text(
                    'SKU: ${rawMaterial.sku}',
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ),

            AppActionMenu(
              items: [
                const AppActionMenuItem(
                  value: 'update',
                  label: 'Ajustar Stock',
                ),
                const AppActionMenuItem(value: 'edit', label: 'Editar'),
                if (isAdmin)
                  const AppActionMenuItem(
                    value: 'delete',
                    label: 'Eliminar',
                    isDestructive: true,
                  ),
              ],
              onSelected: (value) => handleRawMaterialSharedAction(
                context,
                ref,
                rawMaterial,
                value,
                isAdmin,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(rawMaterial.description, style: context.textTheme.titleMedium),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text("Stock Actual", style: context.textTheme.bodySmall),
                Text(rawMaterial.formattedStock),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text("Stock Mínimo", style: context.textTheme.bodySmall),
                Text(rawMaterial.formattedMinStock),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
