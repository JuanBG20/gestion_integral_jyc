import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/pdf/arca_invoice_pdf_generator.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:go_router/go_router.dart';

class SaleInvoiceCard extends ConsumerWidget {
  final SaleEntity sale;

  const SaleInvoiceCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoot = ref.watch(isRootProvider);
    final bill = sale.bill;
    final bool isInvoiced = sale.isInvoiced;
    final bool isManual = bill?.isManual ?? false;

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
          Text("Estado de Facturación", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          if (isInvoiced) ...[
            // Estado: FACTURADO
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        isManual
                            ? "Factura emitida manualmente"
                            : "Factura emitida vía ARCA",
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (!isManual && bill?.arcaData != null)
                        Text(
                          "CAE: ${bill!.arcaData!.cae}",
                          style: context.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // PDF para facturas NO manuales
            if (!isManual) ...[
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
            ],
          ] else ...[
            // Estado: NO FACTURADO
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
                    "Pendiente de facturación",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón de Facturación Manual
            SizedBox(
              width: double.infinity,
              child: QuickActionButton(
                label: 'Marcar como facturada manualmente',
                icon: Icons.done_all,
                onPressed: () async {
                  try {
                    await ref
                        .read(saleProvider.notifier)
                        .markAsManuallyInvoiced(sale.id!);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Venta marcada como facturada'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
              ),
            ),

            // Botón de Facturación Automática
            if (isRoot) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: QuickActionButton(
                  label: 'Facturar Venta',
                  icon: Icons.receipt_long_outlined,
                  onPressed: () =>
                      context.push('/sales/detail/bill', extra: sale),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
