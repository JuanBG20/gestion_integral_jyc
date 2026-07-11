import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:go_router/go_router.dart';

class WorkDetailsScreen extends StatelessWidget {
  final WorkEntity work;

  const WorkDetailsScreen({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Orden TRB-${work.id ?? '---'}",
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        work.client.fullName,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                TextButton.icon(
                  onPressed: () {
                    context.go('/work');
                  },
                  label: Text("Volver al Kanban"),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),

            const SizedBox(height: 32),

            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 840;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 2, child: _buildLeftColumn(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLeftColumn(context),

                        const SizedBox(height: 24),

                        _buildRightColumn(context),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    final completedItems = work.items.where((item) => item.isDone).length;
    final totalItems = work.items.length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("ESTADO", style: context.textTheme.bodySmall),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),

                    child: Text(
                      work.actualState.dbValue,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Text("FECHA LÍMITE", style: context.textTheme.bodySmall),

                  const SizedBox(height: 4),

                  Text(
                    work.deadline != null
                        ? "${work.deadline?.day}/${work.deadline?.month}/${work.deadline?.year}"
                        : '-',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
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

                  Text(
                    "$completedItems/$totalItems ítems completos",
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),

              Divider(color: AppColors.outline),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildItemTile(context, work.items[index]);
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: work.items.length,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final double subtotal = work.items.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Resumen", style: context.textTheme.titleMedium),

              const SizedBox(height: 8),

              Divider(color: AppColors.outline),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text("Productos", style: context.textTheme.bodyMedium),
                  Text("\$$subtotal", style: context.textTheme.bodyMedium),
                ],
              ),

              const SizedBox(height: 8),

              Divider(color: AppColors.outline),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text("Total", style: context.textTheme.titleMedium),
                  Text("\$$subtotal", style: context.textTheme.titleLarge),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Acciones Rápidas", style: context.textTheme.titleMedium),

              const SizedBox(height: 16),

              QuickActionButton(
                label: 'Actualizar Estado',
                icon: Icons.history,
              ),

              const SizedBox(height: 16),

              QuickActionButton(
                label: 'Emitir Presupuesto',
                icon: Icons.print_outlined,
              ),

              const SizedBox(height: 16),

              QuickActionButton(
                label: 'Editar Orden',
                icon: Icons.edit_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemTile(BuildContext context, WorkItemEntity item) {
    final String baseName =
        item.variantProduct?.baseProduct.description ??
        item.description ??
        'Sin descripción';

    String? subtitleText;
    if (item.variantProduct != null) {
      final attributes =
          [
                item.variantProduct!.baseProduct.fullCategory,
                item.variantProduct!.color,
                item.variantProduct!.size,
              ]
              .where(
                (attr) => attr != null && attr.toString().trim().isNotEmpty,
              )
              .toList();

      if (attributes.isNotEmpty) {
        subtitleText = attributes.join(' | ');
      }
    }

    subtitleText ??= 'Subtotal: \$${item.subtotal.toStringAsFixed(2)}';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: CheckboxListTile(
        value: item.isDone,
        onChanged: (bool? newValue) {},
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text('${item.quantity}x $baseName'),
        subtitle: Text(subtitleText),
      ),
    );
  }
}
