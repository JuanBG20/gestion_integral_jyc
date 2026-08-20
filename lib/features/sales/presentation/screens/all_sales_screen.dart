import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_filter_providers.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_filters.dart';
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

    final selectedState = ref.watch(saleStateFilterProvider);
    final selectedMethod = ref.watch(salePaymentMethodFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: context.isMobileLayout
          ? FloatingActionButton(
              onPressed: () => context.go('/sales/new'),
              child: const Icon(Icons.add),
            )
          : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Ventas y Facturación",
              subtitle:
                  "Registra ventas, controla las transacciones y emite facturas.",
              buttonLabel: "Nueva Venta",
              onPressed: () => context.go('/sales/new'),
            ),

            const SizedBox(height: 24),

            SaleFilters(
              selectedState: selectedState,
              selectedMethod: selectedMethod,
            ),

            const SizedBox(height: 24),

            salesState.when(
              data: (sales) {
                if (sales.isEmpty) {
                  return const Center(
                    child: Text("No hay ventas registradas."),
                  );
                }

                var processedSales = sales.where((sale) {
                  // Filtro por Estado
                  if (selectedState != null) {
                    if (selectedState == 'withoutPayment' && sale.isPaid) {
                      return false;
                    }

                    if (selectedState == 'withoutBill' && sale.isInvoiced) {
                      return false;
                    }
                  }

                  // Filtro por Método de Pago
                  if (selectedMethod != null &&
                      sale.paymentMethod != selectedMethod) {
                    return false;
                  }

                  return true;
                }).toList();

                if (processedSales.isEmpty) {
                  return const Center(
                    child: Text("No se encontraron ventas con estos filtros."),
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
                        trailingWidth: 40,
                      ),
                      rows: processedSales
                          .map(
                            (sale) =>
                                SaleTableRow(sale: sale, trailingWidth: 40),
                          )
                          .toList(),
                    ),

                    PaginationFooter(
                      total: sales.length,
                      shown: processedSales.length,
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
