import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
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
            ScreenHeader(
              title: "Ventas y Facturación",
              subtitle:
                  "Registra ventas, controla las transacciones y emite facturas.",
              buttonLabel: "Nueva Venta",
              onPressed: () => context.go('/sales/new'),
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
                          .map(
                            // TODO: Modificar forma de acceso a detalle
                            (sale) => GestureDetector(
                              onTap: () =>
                                  context.go('/sales/detail', extra: sale),
                              child: SaleTableRow(sale: sale),
                            ),
                          )
                          .toList(),
                    ),

                    PaginationFooter(
                      total: sales.length,
                      shown: sales.length,
                      label: 'ventas',
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
}
