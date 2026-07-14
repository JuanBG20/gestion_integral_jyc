import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/items_card_layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/item_tile.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/production_quick_actions.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/summary_products_card.dart';
import 'package:go_router/go_router.dart';

class WorkDetailsScreen extends ConsumerWidget {
  final WorkEntity initialWork;

  const WorkDetailsScreen({super.key, required this.initialWork});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);

    final currentList = worksState.value ?? [];
    final matches = currentList.where((w) => w.id == initialWork.id);
    final currentWork = matches.isNotEmpty ? matches.first : initialWork;

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
                        "Orden TRB-${currentWork.id ?? '---'}",
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        currentWork.client.fullName,
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
                if (constraints.isDesktopLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLeftColumn(context, ref, currentWork),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRightColumn(context, ref, currentWork),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLeftColumn(context, ref, currentWork),

                        const SizedBox(height: 24),

                        _buildRightColumn(context, ref, currentWork),
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

  Widget _buildLeftColumn(
    BuildContext context,
    WidgetRef ref,
    WorkEntity work,
  ) {
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
                    work.deadline != null ? work.deadline!.ddMMyyyy : '-',
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

        ItemsCardLayout(
          itemCount: work.items.length,
          itemsSubtitle: "$completedItems/$totalItems ítems completos",
          itemBuilder: (context, index) => ItemTile(item: work.items[index]),
        ),
      ],
    );
  }

  Widget _buildRightColumn(
    BuildContext context,
    WidgetRef ref,
    WorkEntity work,
  ) {
    final double subtotal = work.items.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );

    return Column(
      children: [
        SummaryProductsCard(subtotal: subtotal),

        const SizedBox(height: 16),

        ProductionQuickActions(work: work),
      ],
    );
  }
}
