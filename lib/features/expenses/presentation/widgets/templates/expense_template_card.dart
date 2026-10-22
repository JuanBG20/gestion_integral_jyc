import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/info_budget.dart';
import 'package:go_router/go_router.dart';

class ExpenseTemplateCard extends ConsumerWidget {
  final ExpenseTemplateEntity template;
  final bool isAdmin;

  const ExpenseTemplateCard({
    super.key,
    required this.template,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Primera letra en mayúsculas, el resto en minúsculas
    final frequency =
        template.frequency.name[0].toUpperCase() +
        template.frequency.name.substring(1).toLowerCase();

    final isFixedAmount = template.amountType.name.toLowerCase() == 'fijo';

    return AppCardShell(
      onTapCard: () => context.push('/expenses/edit-template', extra: template),
      cardContent: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            InfoBudget(text: template.category.name),

            Row(
              children: [
                Switch(
                  value: template.isActive,
                  onChanged: isAdmin
                      ? (value) {
                          if (template.id != null) {
                            ref
                                .read(expenseTemplateProvider.notifier)
                                .toggleTemplateStatus(template.id!, value);
                          }
                        }
                      : null,
                  activeThumbColor: AppColors.primary,
                ),

                AppActionMenu(
                  items: const [
                    AppActionMenuItem(value: 'edit', label: 'Editar'),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push('/expenses/edit-template', extra: template);
                    }
                  },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          template.description,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "Frecuencia: $frequency (Día ${template.dueDay.toString().padLeft(2, '0')})",
          style: context.textTheme.bodySmall,
        ),

        const SizedBox(height: 16),
        Divider(color: AppColors.outline),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  isFixedAmount ? "Monto Fijo" : "Tipo de Monto",
                  style: context.textTheme.bodySmall,
                ),

                Text(
                  isFixedAmount
                      ? '\$${template.amount?.toStringAsFixed(2) ?? '0.00'}'
                      : 'Variable',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
