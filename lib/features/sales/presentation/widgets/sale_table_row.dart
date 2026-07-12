import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:intl/intl.dart';

class SaleTableRow extends StatelessWidget {
  final SaleEntity sale;

  const SaleTableRow({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: 0,
      cells: [
        AppTableCell.text(
          'VTA-${sale.id ?? ''}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          sale.client.fullName,
          flex: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          DateFormat('dd/MM/yyyy').format(sale.date),
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          sale.paymentMethod.dbValue,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          '\$${sale.finalAmount.toStringAsFixed(2)}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,

            child: _buildArcaIndicator(context, hasCae: false),
          ),
        ),
      ],
    );
  }

  Widget _buildArcaIndicator(BuildContext context, {required bool hasCae}) {
    if (hasCae) {
      return Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(
            "CAE",
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Icon(Icons.description_outlined, color: AppColors.primary);
  }
}
