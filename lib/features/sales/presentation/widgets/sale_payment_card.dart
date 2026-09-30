import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';

class SalePaymentCard extends ConsumerStatefulWidget {
  final SaleEntity sale;
  final List<DiscountEntity> additionalDiscounts;

  const SalePaymentCard({
    super.key,
    required this.sale,
    required this.additionalDiscounts,
  });

  @override
  ConsumerState<SalePaymentCard> createState() => _SalePaymentCardState();
}

class _SalePaymentCardState extends ConsumerState<SalePaymentCard> {
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Cobrar Venta", style: context.textTheme.titleMedium),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          PaymentMethodSelector(
            onMethodChanged: (method) {
              setState(() {
                _selectedMethod = method;
              });
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                if (widget.sale.id != null) {
                  ref
                      .read(saleProvider.notifier)
                      .markSaleAsPaid(
                        widget.sale.id!,
                        _selectedMethod,
                        additionalDiscounts: widget.additionalDiscounts,
                      );
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Venta cobrada exitosamente')),
                  );
                }
              },

              child: const Text('Confirmar Cobro'),
            ),
          ),
        ],
      ),
    );
  }
}
