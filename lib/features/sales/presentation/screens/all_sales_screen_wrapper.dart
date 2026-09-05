import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_filter_providers.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/all_sales_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_card.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_filters.dart';
import 'package:go_router/go_router.dart';

class AllSalesScreenWrapper extends ConsumerWidget {
  const AllSalesScreenWrapper({super.key});

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

                return context.isMobileLayout
                    ? AppMobileList<SaleEntity>(
                        items: processedSales,
                        itemBuilder: (context, sale) => SaleCard(sale: sale),
                      )
                    : AllSalesScreen(sales: processedSales);
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
