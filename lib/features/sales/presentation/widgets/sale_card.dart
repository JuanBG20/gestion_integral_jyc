import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/utils/sale_action_handler.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_status_badge.dart';
import 'package:go_router/go_router.dart';

class SaleCard extends StatelessWidget {
  final SaleEntity sale;

  const SaleCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final String status = sale.isPaid
        ? sale.isInvoiced
              ? 'FACTURADA'
              : 'SIN FACTURAR'
        : 'PENDIENTE DE PAGO';

    return AppCardShell(
      onTapCard: () => context.go('/sales/detail', extra: sale),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'VTA-${sale.id ?? ''}',
                    style: context.textTheme.titleMedium,
                  ),

                  Text(sale.date.ddMMyyyy, style: context.textTheme.bodyLarge),
                ],
              ),
            ),

            AppActionMenu(
              items: [
                const AppActionMenuItem(
                  value: 'detail',
                  label: 'Ver Detalle',
                  icon: Icons.visibility_outlined,
                ),

                if (!sale.isInvoiced && sale.isPaid)
                  AppActionMenuItem(value: 'bill', label: 'Facturar'),
              ],
              onSelected: (value) =>
                  handleSaleSharedAction(context, value, sale),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          sale.client.fullName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        SaleStatusBadge(status: status),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(sale.paymentMethod?.dbValue ?? 'PENDIENTE'),

            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,

                child: Text(
                  "\$${sale.finalAmount.toStringAsFixed(2)}",
                  style: context.textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
