import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
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
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/status_badge.dart';

class ClientWorksHistory extends StatelessWidget {
  final List<WorkEntity> works;
  final String emptyMessage;
  final ValueChanged<WorkEntity> onOpen;

  const ClientWorksHistory({
    super.key,
    required this.works,
    required this.emptyMessage,
    required this.onOpen,
  });

  static const _columns = [
    AppTableColumn(label: "ID", flex: 1),
    AppTableColumn(label: "CREACIÓN", flex: 1),
    AppTableColumn(label: "ÍTEMS", flex: 5),
    AppTableColumn(label: "TOTAL", flex: 2),
    AppTableColumn(label: "ESTADO", flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    if (works.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text(emptyMessage)),
      );
    }

    if (context.isMobileLayout) {
      return AppMobileList<WorkEntity>(
        items: works,
        itemBuilder: (context, work) => _buildCard(context, work),
      );
    }

    return ClientHistoryTable<WorkEntity>(
      columns: _columns,
      items: works,
      label: 'trabajos',
      rowBuilder: (work) => _buildRow(context, work),
    );
  }

  Widget _buildRow(BuildContext context, WorkEntity work) {
    return AppTableRow(
      onTap: () => onOpen(work),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: 0,
      cells: [
        AppTableCell.text(
          'TRB-${work.id ?? ''}',
          flex: 1,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          work.creationDate.ddMMyyyy,
          flex: 1,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: ClientHistoryItems(items: work.items),
          ),
        ),
        AppTableCell(flex: 2, child: _buildTotal(context, work)),
        AppTableCell(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(status: work.actualState.dbValue),
          ),
        ),
      ],
    );
  }

  Widget _buildTotal(BuildContext context, WorkEntity work) {
    final isFinished = work.actualState == WorkState.finalizado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          '\$${work.totalAmount.toStringAsFixed(2)}',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!isFinished && work.totalPaid > 0)
          Text(
            'Seña \$${work.totalPaid.toStringAsFixed(2)}',
            style: context.textTheme.bodySmall,
          ),
        if (!isFinished && work.totalOutstanding > 0)
          Text(
            'Debe \$${work.totalOutstanding.toStringAsFixed(2)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.deadlineRed,
            ),
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, WorkEntity work) {
    return AppCardShell(
      onTapCard: () => onOpen(work),
      cardContent: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text('TRB-${work.id ?? ''}', style: context.textTheme.titleMedium),
            Text(
              work.creationDate.ddMMyyyy,
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),

        const SizedBox(height: 8),

        StatusBadge(status: work.actualState.dbValue),

        const SizedBox(height: 8),

        ClientHistoryItems(items: work.items),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Align(
          alignment: Alignment.centerRight,
          child: _buildTotal(context, work),
        ),
      ],
    );
  }
}
