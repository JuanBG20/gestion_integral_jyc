import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';

class ClientHistoryTable<T> extends StatefulWidget {
  final List<AppTableColumn> columns;
  final List<T> items;
  final Widget Function(T item) rowBuilder;
  final String label;

  const ClientHistoryTable({
    super.key,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    required this.label,
  });

  static const pageSize = 20;

  @override
  State<ClientHistoryTable<T>> createState() => _ClientHistoryTableState<T>();
}

class _ClientHistoryTableState<T> extends State<ClientHistoryTable<T>> {
  int _page = 0;

  int get _lastPage {
    final total = widget.items.length;
    if (total == 0) return 0;
    return (total - 1) ~/ ClientHistoryTable.pageSize;
  }

  @override
  void didUpdateWidget(covariant ClientHistoryTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_page > _lastPage) _page = _lastPage;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.items.length;
    final start = _page * ClientHistoryTable.pageSize;
    final pageItems = widget.items
        .skip(start)
        .take(ClientHistoryTable.pageSize)
        .toList();

    return Column(
      children: [
        AppTableShell(
          shrinkWrap: true,
          minWidth: 1000,
          header: AppTableHeader(
            columns: widget.columns,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            trailingWidth: 0,
          ),
          rows: pageItems.map(widget.rowBuilder).toList(),
        ),
        PaginationFooter(
          total: total,
          start: start,
          shown: pageItems.length,
          label: widget.label,
          onPrevious: _page > 0 ? () => setState(() => _page--) : null,
          onNext: _page < _lastPage ? () => setState(() => _page++) : null,
        ),
      ],
    );
  }
}
