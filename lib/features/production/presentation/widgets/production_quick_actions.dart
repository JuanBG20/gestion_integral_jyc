import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_actions_layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/partial_payment_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/budget_pdf_generator.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
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
          label: 'Añadir Seña',
          icon: Icons.attach_money,
          onPressed: () => _showAddPaymentDialog(context, ref, work),
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

  void _showAddPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    WorkEntity work,
  ) {
    final amountController = TextEditingController();
    PaymentMethod selectedMethod = PaymentMethod.efectivo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text('Añadir Seña', style: context.textTheme.titleMedium),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                LabeledTextField(
                  controller: amountController,
                  label: 'Monto',
                  hint: '5000',
                  inputType: TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.attach_money),
                ),

                const SizedBox(height: 24),

                PaymentMethodSelector(
                  onMethodChanged: (method) {
                    selectedMethod = method;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                final amountText = amountController.text.replaceAll(',', '.');
                final amount = double.tryParse(amountText);

                if (amount != null && amount > 0 && work.id != null) {
                  final newPayment = PartialPaymentEntity(
                    amount: amount,
                    date: DateTime.now(),
                    paymentMethod: selectedMethod,
                    workId: work.id!,
                  );

                  ref
                      .read(workProvider.notifier)
                      .registerPartialPayment(newPayment);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingresá un monto válido'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
