import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_table_row.dart';

class AllSalesScreen extends StatefulWidget {
  final List<SaleEntity> sales;

  const AllSalesScreen({super.key, required this.sales});

  static const pageSize = 20;

  @override
  State<AllSalesScreen> createState() => _AllSalesScreenState();
}

class _AllSalesScreenState extends State<AllSalesScreen> {
  static const _salesColumns = [
    AppTableColumn(label: "ID", flex: 2),
    AppTableColumn(label: "CLIENTE", flex: 3),
    AppTableColumn(label: "FECHA", flex: 2),
    AppTableColumn(label: "MÉTODO", flex: 2),
    AppTableColumn(label: "MONTO", flex: 2),
    AppTableColumn(label: "ARCA", flex: 1),
  ];

  int _page = 0;

  @override
  void didUpdateWidget(covariant AllSalesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final lastPage = _lastPage;
    if (_page > lastPage) _page = lastPage;
  }

  int get _lastPage {
    final total = widget.sales.length;
    if (total == 0) return 0;
    return (total - 1) ~/ AllSalesScreen.pageSize;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.sales.length;
    final start = _page * AllSalesScreen.pageSize;
    final pageSales = widget.sales
        .skip(start)
        .take(AllSalesScreen.pageSize)
        .toList();

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
          rows: pageSales
              .map((sale) => SaleTableRow(sale: sale, trailingWidth: 40))
              .toList(),
        ),
        PaginationFooter(
          total: total,
          start: start,
          shown: pageSales.length,
          label: 'ventas',
          onPrevious: _page > 0 ? () => setState(() => _page--) : null,
          onNext: _page < _lastPage ? () => setState(() => _page++) : null,
        ),
      ],
    );
  }
}
