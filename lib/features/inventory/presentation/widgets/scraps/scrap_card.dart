import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/scrap_action_handler.dart';
import 'package:go_router/go_router.dart';

class ScrapCard extends ConsumerWidget {
  final ScrapEntity scrap;
  final bool isAdmin;

  const ScrapCard({super.key, required this.scrap, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCardShell(
      onTapCard: () => context.go('/inventory/edit-scrap', extra: scrap),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Text(
                scrap.rawMaterial.description,
                style: context.textTheme.titleMedium,
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
              onSelected: (value) =>
                  handleScrapSharedAction(context, ref, scrap, value, isAdmin),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text("Dimensiones", style: context.textTheme.bodySmall),
                Text('${scrap.width} x ${scrap.height} cm'),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text("Stock", style: context.textTheme.bodySmall),
                Text('${scrap.stock} unidades'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
