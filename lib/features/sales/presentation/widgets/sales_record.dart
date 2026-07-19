import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_table_row.dart';
import 'package:go_router/go_router.dart';

class SalesRecord extends ConsumerWidget {
  const SalesRecord({super.key});

  static const _salesColumns = [
    AppTableColumn(label: "ID", flex: 2),
    AppTableColumn(label: "CLIENTE", flex: 3),
    AppTableColumn(label: "FECHA", flex: 2),
    AppTableColumn(label: "MÉTODO", flex: 2),
    AppTableColumn(label: "MONTO", flex: 2),
    AppTableColumn(label: "ARCA", flex: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(saleProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Registro de Ventas", style: context.textTheme.titleMedium),

              TextButton.icon(
                onPressed: () {
                  context.go('/sales/all');
                },
                label: Text("Ver todas"),
                icon: Icon(Icons.arrow_forward),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),

          const SizedBox(height: 16),

          salesState.when(
            data: (sales) {
              if (sales.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text("No hay ventas registradas.")),
                );
              }

              return AppTableShell(
                shrinkWrap: true,
                minWidth: 600,
                header: const AppTableHeader(
                  columns: _salesColumns,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  trailingWidth: 0,
                ),
                rows: sales
                    .take(5)
                    .map((venta) => SaleTableRow(sale: venta, trailingWidth: 0))
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, stack) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}
