import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_actions_layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/budget_pdf_generator.dart';
import 'package:go_router/go_router.dart';

class ProductionQuickActions extends ConsumerWidget {
  final WorkEntity work;

  const ProductionQuickActions({super.key, required this.work});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuickActionsLayout(
      quickActions: [
        QuickActionButton(
          label: 'Actualizar Estado',
          icon: Icons.history,
          onPressed: () => _showUpdateStateDialog(context, ref, work),
        ),

        QuickActionButton(
          label: 'Emitir Presupuesto',
          icon: Icons.print_outlined,
          onPressed: () => BudgetPdfGenerator.generateAndPreviewBudget(work),
        ),

        QuickActionButton(
          label: 'Editar Orden',
          icon: Icons.edit_outlined,
          onPressed: () => context.go('/work/edit', extra: work),
        ),
      ],
    );
  }

  void _showUpdateStateDialog(
    BuildContext context,
    WidgetRef ref,
    WorkEntity work,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Actualizar Estado',
            style: context.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: WorkState.values.map((state) {
              final isCurrent = state == work.actualState;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                tileColor: isCurrent
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                title: Text(
                  state.dbValue,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isCurrent
                        ? AppColors.primary
                        : AppColors.onBackground,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                leading: isCurrent
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.circle_outlined),
                onTap: () {
                  if (!isCurrent && work.id != null) {
                    ref
                        .read(workProvider.notifier)
                        .updateWorkStatus(work.id!, state);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
