import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/utils/sale_action_handler.dart';

class SaleTableRow extends ConsumerWidget {
  final SaleEntity sale;
  final double trailingWidth;

  const SaleTableRow({
    super.key,
    required this.sale,
    required this.trailingWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoot = ref.watch(isRootProvider);

    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: trailingWidth,
      trailing: trailingWidth != 0
          ? AppActionMenu(
              items: [
                const AppActionMenuItem(
                  value: 'detail',
                  label: 'Ver Detalle',
                  icon: Icons.visibility_outlined,
                ),

                if (!sale.isInvoiced && sale.isPaid) ...[
                  const AppActionMenuItem(
                    value: 'manual_bill',
                    label: 'Marcar como Facturada',
                    icon: Icons.done_all,
                  ),

                  if (isRoot)
                    const AppActionMenuItem(
                      value: 'bill',
                      label: 'Facturar con ARCA',
                      icon: Icons.receipt_long_outlined,
                    ),
                ],
              ],
              onSelected: (value) =>
                  handleSaleSharedAction(context, ref, value, sale),
            )
          : null,

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
          sale.date.ddMMyyyy,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          sale.paymentMethod?.dbValue ?? 'PENDIENTE',
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

            child: _buildArcaIndicator(context, hasCae: sale.isInvoiced),
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
