import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/add_expense_dialog.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/breakdown_card.dart';

class RegisteredExpensesCard extends StatelessWidget {
  final double? width;
  final String totalAmount;
  final List<BreakdownRowItemEntity> items;

  const RegisteredExpensesCard({
    super.key,
    this.width,
    required this.totalAmount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BreakdownCard(
      width: width,
      title: "Gastos Registrados",
      badgeText: totalAmount,
      badgeColor: AppColors.error,
      col1Header: "Descripción",
      col2Header: "Categoría",
      col3Header: "Monto",
      col2Flex: 3,
      items: items,
      onTap: () => showDialog(
        context: context,
        builder: (context) => const AddExpenseDialog(),
      ),
    );
  }
}
