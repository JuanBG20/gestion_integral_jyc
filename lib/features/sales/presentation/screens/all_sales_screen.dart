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

class AllSalesScreen extends ConsumerWidget {
  const AllSalesScreen({super.key});

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

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Ventas y Facturación",
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        "Registra ventas, controla las transacciones y emite facturas.",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                ElevatedButton.icon(
                  onPressed: () => context.go('/sales/new'),
                  label: Text("Nueva Venta"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 32),

            salesState.when(
              data: (sales) {
                if (sales.isEmpty) {
                  return const Center(
                    child: Text("No hay ventas registradas."),
                  );
                }

                return Column(
                  children: [
                    AppTableShell(
                      shrinkWrap: true,
                      minWidth: 1200,
                      header: const AppTableHeader(
                        columns: _salesColumns,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        trailingWidth: 0,
                      ),
                      rows: sales
                          .map((sale) => SaleTableRow(sale: sale))
                          .toList(),
                    ),

                    _buildPaginationFooter(
                      context,
                      total: sales.length,
                      shown: sales.length,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(
    BuildContext context, {
    required int total,
    required int shown,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            "Mostrando 1-$shown de $total clientes",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onBackground,
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
