import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_table_row.dart';

class AllSalesScreen extends StatelessWidget {
  final List<SaleEntity> sales;

  const AllSalesScreen({super.key, required this.sales});

  static const _salesColumns = [
    AppTableColumn(label: "ID", flex: 2),
    AppTableColumn(label: "CLIENTE", flex: 3),
    AppTableColumn(label: "FECHA", flex: 2),
    AppTableColumn(label: "MÉTODO", flex: 2),
    AppTableColumn(label: "MONTO", flex: 2),
    AppTableColumn(label: "ARCA", flex: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTableShell(
          shrinkWrap: true,
          minWidth: 1200,
          header: const AppTableHeader(
            columns: _salesColumns,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            trailingWidth: 40,
          ),
          rows: sales
              .map((sale) => SaleTableRow(sale: sale, trailingWidth: 40))
              .toList(),
        ),
        PaginationFooter(
          total: sales.length,
          shown: sales.length,
          label: 'ventas',
        ),
      ],
    );
  }
}
