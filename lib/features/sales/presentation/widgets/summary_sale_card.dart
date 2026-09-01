import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_summary_item_card.dart';

class SummarySaleCard extends StatelessWidget {
  final List<SaleItemEntity> currentItems;
  final List<DiscountEntity> currentDiscounts;
  final ValueChanged<PaymentMethod> onPaymentMethodChange;
  final bool showPaymentMethods;

  const SummarySaleCard({
    super.key,
    required this.currentItems,
    required this.onPaymentMethodChange,
    this.showPaymentMethods = true,
    this.currentDiscounts = const [],
  });

  double get _subtotalAmount =>
      currentItems.fold(0, (sum, item) => sum + item.subtotal);

  double get _discountsAmount =>
      currentDiscounts.fold(0, (sum, discount) => sum + discount.amount);

  double get _totalAmount => _subtotalAmount - _discountsAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Resumen", style: context.textTheme.titleMedium),

          const SizedBox(height: 8),

          Divider(color: AppColors.outline),

          const SizedBox(height: 8),

          if (currentItems.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Aún no agregó productos.",
                style: context.textTheme.bodySmall,
              ),
            ),
          ] else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  SaleSummaryItemCard(item: currentItems[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: currentItems.length,
            ),

          const SizedBox(height: 8),

          Divider(color: AppColors.outline),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Subtotal", style: context.textTheme.bodyMedium),
              Text(
                "\$${_subtotalAmount.toStringAsFixed(2)}",
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),

          if (currentDiscounts.isNotEmpty) ...[
            const SizedBox(height: 4),

            ...currentDiscounts.map(
              (discount) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Desc. ${discount.reason}",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                  ),

                  Text(
                    "- \$${discount.amount.toStringAsFixed(2)}",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),

          Divider(color: AppColors.outline),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Total", style: context.textTheme.titleMedium),
              Text(
                "\$${_totalAmount.toStringAsFixed(2)}",
                style: context.textTheme.titleLarge,
              ),
            ],
          ),

          if (showPaymentMethods) ...[
            const SizedBox(height: 16),

            PaymentMethodSelector(onMethodChanged: onPaymentMethodChange),
          ],
        ],
      ),
    );
  }
}
