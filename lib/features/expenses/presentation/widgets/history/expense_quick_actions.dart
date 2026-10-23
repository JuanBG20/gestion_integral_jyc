import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_actions_layout.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/confirm_payment_dialog.dart';
import 'package:go_router/go_router.dart';

class ExpenseQuickActions extends StatelessWidget {
  final ExpenseEntity expense;
  final bool isPaid;

  const ExpenseQuickActions({
    super.key,
    required this.expense,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionsLayout(
      quickActions: [
        if (!isPaid)
          QuickActionButton(
            label: 'Registrar Pago',
            icon: Icons.payment,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ConfirmPaymentDialog(expense: expense),
            ),
          ),

        QuickActionButton(
          label: 'Editar Orden',
          icon: Icons.edit_outlined,
          onPressed: () => context.push('/expenses/edit', extra: expense),
        ),
      ],
    );
  }
}
