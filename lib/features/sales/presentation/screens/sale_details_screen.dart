import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/items_card_layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/summary_products_card.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/utils/discount_calculator.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_client_info_card.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_invoice_card.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_payment_card.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_summary_item_card.dart';
import 'package:go_router/go_router.dart';

class SaleDetailsScreen extends ConsumerStatefulWidget {
  final SaleEntity sale;

  const SaleDetailsScreen({super.key, required this.sale});

  @override
  ConsumerState<SaleDetailsScreen> createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends ConsumerState<SaleDetailsScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(saleProvider);
    final currentSale = salesAsync.maybeWhen(
      data: (sales) {
        for (final s in sales) {
          if (s.id == widget.sale.id) return s;
        }
        return widget.sale;
      },
      orElse: () => widget.sale,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            _buildHeader(context, currentSale),

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
                        child: _buildRightColumn(context, ref, currentSale),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context, currentSale),
                      const SizedBox(height: 24),
                      _buildRightColumn(context, ref, currentSale),
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

  Widget _buildHeader(BuildContext context, SaleEntity currentSale) {
    return Row(
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
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/sales');
              }
            },
            label: Text("Volver a Ventas"),
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ],
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

  Widget _buildRightColumn(
    BuildContext context,
    WidgetRef ref,
    SaleEntity sale,
  ) {
    final double totalPaid = sale.work?.totalPaid ?? 0;
    List<DiscountEntity> additionalDiscounts = [];

    if (!sale.isPaid) {
      additionalDiscounts = DiscountCalculator.calculatePaymenthMethodDiscounts(
        method: _selectedMethod,
        subtotal: sale.subtotal,
      );
    }

    final allDiscounts = [...sale.discounts, ...additionalDiscounts];
    final totalDiscountsAmount = allDiscounts.fold(
      0.0,
      (sum, d) => sum + d.amount,
    );
    final projectedFinalAmount = sale.subtotal - totalDiscountsAmount;
    final projectedOutstanding = projectedFinalAmount - totalPaid;

    return Column(
      children: [
        SummaryProductsCard(
          totalAmount: projectedFinalAmount,
          totalPaid: totalPaid,
          totalOutstanding: projectedOutstanding,
          subtotal: sale.subtotal,
          discounts: allDiscounts,
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
                sale.paymentMethod?.dbValue ?? 'PENDIENTE',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        if (!sale.isPaid) ...[
          SalePaymentCard(sale: sale, additionalDiscounts: additionalDiscounts),
        ] else ...[
          const SizedBox(height: 16),

          SaleInvoiceCard(sale: sale),
        ],
      ],
    );
  }
}
