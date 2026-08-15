import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/items_card_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/summary_products_card.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/pdf/arca_invoice_pdf_generator.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_client_info_card.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_summary_item_card.dart';
import 'package:go_router/go_router.dart';

class SaleDetailsScreen extends ConsumerWidget {
  final SaleEntity sale;

  const SaleDetailsScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(saleProvider);
    final currentSale = salesAsync.maybeWhen(
      data: (sales) {
        for (final s in sales) {
          if (s.id == sale.id) return s;
        }
        return sale;
      },
      orElse: () => sale,
    );

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
                        "Venta VTA-${currentSale.id ?? '---'}",
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        "Registrada el ${currentSale.date.ddMMyyyy} - ${currentSale.date.hour}:${currentSale.date.minute} hrs",
                        style: context.textTheme.bodyLarge,
                      ),
                      if (currentSale.work != null)
                        Text(
                          "Corresponde al trabajo TRB-${currentSale.work!.id}",
                          style: context.textTheme.bodyLarge,
                        ),
                    ],
                  ),
                ),

                if (!context.isMobileLayout) ...[
                  const SizedBox(width: 16),

                  TextButton.icon(
                    onPressed: () {
                      context.go('/sales');
                    },
                    label: Text("Volver a Ventas"),
                    icon: Icon(Icons.arrow_back),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 32),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.isDesktopLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLeftColumn(context, currentSale),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRightColumn(context, currentSale),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context, currentSale),
                      const SizedBox(height: 24),
                      _buildRightColumn(context, currentSale),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, SaleEntity sale) {
    return Column(
      children: [
        SaleClientInfoCard(client: sale.client),

        const SizedBox(height: 16),

        ItemsCardLayout(
          itemCount: sale.items.length,
          itemsSubtitle: "${sale.items.length} ítems",
          itemBuilder: (context, index) =>
              SaleSummaryItemCard(item: sale.items[index]),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, SaleEntity sale) {
    final double totalAmount = sale.items.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );
    final double totalPaid = sale.work?.totalPaid ?? 0;
    final double totalOutstanding = totalAmount - totalPaid;

    return Column(
      children: [
        SummaryProductsCard(
          totalAmount: totalAmount,
          totalPaid: totalPaid,
          totalOutstanding: totalOutstanding,
        ),

        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Método de Pago", style: context.textTheme.bodyMedium),
              Text(
                sale.paymentMethod.dbValue,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildInvoiceCard(context, sale),
      ],
    );
  }

  Widget _buildInvoiceCard(BuildContext context, SaleEntity sale) {
    final bill = sale.bill;
    final bool isInvoiced = sale.isInvoiced;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Facturación ARCA", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          if (isInvoiced) ...[
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Factura emitida",
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "CAE: ${bill?.arcaData.cae}",
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: QuickActionButton(
                label: 'Ver Factura',
                icon: Icons.description_outlined,
                onPressed: () async {
                  try {
                    await ArcaInvoicePdfGenerator.previewInvoice(sale);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al mostrar la factura: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.onBackground,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Factura no emitida",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: QuickActionButton(
                label: 'Facturar Venta',
                icon: Icons.receipt_long_outlined,
                onPressed: () => context.go('/sales/detail/bill', extra: sale),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
