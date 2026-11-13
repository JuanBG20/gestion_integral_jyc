import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/client_history_items.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/client_history_table.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_status_badge.dart';

class ClientSalesHistory extends StatelessWidget {
  final List<SaleEntity> sales;
  final String emptyMessage;
  final ValueChanged<SaleEntity> onOpen;

  const ClientSalesHistory({
    super.key,
    required this.sales,
    required this.emptyMessage,
    required this.onOpen,
  });

  static const _columns = [
    AppTableColumn(label: "ID", flex: 1),
    AppTableColumn(label: "FECHA", flex: 1),
    AppTableColumn(label: "PRODUCTOS", flex: 5),
    AppTableColumn(label: "TOTAL", flex: 2),
    AppTableColumn(label: "ESTADO", flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text(emptyMessage)),
      );
    }

    if (context.isMobileLayout) {
      return AppMobileList<SaleEntity>(
        items: sales,
        itemBuilder: (context, sale) => _buildCard(context, sale),
      );
    }

    return ClientHistoryTable<SaleEntity>(
      columns: _columns,
      items: sales,
      label: 'ventas',
      rowBuilder: (sale) => _buildRow(context, sale),
    );
  }

  Widget _buildRow(BuildContext context, SaleEntity sale) {
    return AppTableRow(
      onTap: () => onOpen(sale),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: 0,
      cells: [
        AppTableCell.text(
          'VTA-${sale.id ?? ''}',
          flex: 1,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          sale.date.ddMMyyyy,
          flex: 1,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: ClientHistoryItems(items: sale.items),
          ),
        ),
        AppTableCell(flex: 2, child: _buildTotal(context, sale)),
        AppTableCell(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SaleStatusBadge.fromSale(sale),
          ),
        ),
      ],
    );
  }

  Widget _buildTotal(BuildContext context, SaleEntity sale) {
    final hasDiscount = sale.subtotal > sale.finalAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          '\$${sale.finalAmount.toStringAsFixed(2)}',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (hasDiscount)
          Text(
            'Subtotal \$${sale.subtotal.toStringAsFixed(2)}',
            style: context.textTheme.bodySmall,
          ),
        if (sale.work != null)
          Text(
            'Trabajo TRB-${sale.work!.id}',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, SaleEntity sale) {
    return AppCardShell(
      onTapCard: () => onOpen(sale),
      cardContent: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text('VTA-${sale.id ?? ''}', style: context.textTheme.titleMedium),
            Text(sale.date.ddMMyyyy, style: context.textTheme.bodyLarge),
          ],
        ),

        const SizedBox(height: 8),

        SaleStatusBadge.fromSale(sale),

        const SizedBox(height: 8),

        ClientHistoryItems(items: sale.items),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(sale.paymentMethod?.dbValue ?? 'PENDIENTE'),
            Flexible(child: _buildTotal(context, sale)),
          ],
        ),
      ],
    );
  }
}
