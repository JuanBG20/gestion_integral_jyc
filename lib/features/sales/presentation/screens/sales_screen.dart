import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

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

            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 800;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 6, child: _buildLeftColumn(context, ref)),

                      const SizedBox(width: 24),

                      Expanded(flex: 4, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context, ref),
                      const SizedBox(height: 24),
                      _buildRightColumn(context),
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

  Widget _buildLeftColumn(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(saleProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Registro de Ventas",
                    style: context.textTheme.titleMedium,
                  ),

                  TextButton.icon(
                    onPressed: () {},
                    label: Text("Ver todas"),
                    icon: Icon(Icons.arrow_forward),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              salesState.when(
                data: (sales) {
                  if (sales.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text("No hay ventas registradas.")),
                    );
                  }

                  return AppTableShell(
                    shrinkWrap: true,
                    minWidth: 600,
                    header: const AppTableHeader(
                      columns: _salesColumns,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      trailingWidth: 16,
                    ),
                    rows: sales
                        .map((venta) => _buildSaleRow(context, venta: venta))
                        .toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, stack) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: Text("Error: $e")),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.outline),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.sync, color: AppColors.primary),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Movimientos Mercado Pago",
                      style: context.textTheme.titleMedium,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(2),
                    ),

                    child: Text(
                      "Última act: Hace 2 min",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text("Cobro QR", style: context.textTheme.bodyMedium),
                          Text(
                            "17/05/2026",
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    Text("\$24500"),

                    const SizedBox(width: 16),

                    SizedBox(width: 40, child: _buildActionMenu(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
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
          Text("Venta Rápida", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Cliente",
            hint: "Venta en caja",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Producto",
            hint: "Producto Genérico",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Material",
            hint: "PLA",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Consumo (g/cm2)",
            hint: "150",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Monto Final",
            hint: "0.00",
          ),

          const SizedBox(height: 16),

          PaymentMethodSelector(onMethodChanged: (PaymentMethod value) {}),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {},
              child: Text("Registrar Venta"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleRow(BuildContext context, {required SaleEntity venta}) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: 16,
      cells: [
        AppTableCell.text(
          'VTA-${venta.id ?? ''}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          venta.client.fullName,
          flex: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          DateFormat('dd/MM/yyyy').format(venta.date),
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          venta.paymentMethod.dbValue,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          '\$${venta.finalAmount.toStringAsFixed(2)}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,

            child: _buildArcaIndicator(context, hasCae: false),
          ),
        ),
      ],
    );
  }

  Widget _buildArcaIndicator(BuildContext context, {required bool hasCae}) {
    if (hasCae) {
      return Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(
            "CAE",
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Icon(Icons.description_outlined, color: AppColors.primary);
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {},
      itemBuilder: (context) => [
        // TODO: Acomodar values
        const PopupMenuItem(value: 'update', child: Text('Facturar')),
        const PopupMenuItem(value: 'edit', child: Text('Vincular a Venta')),
      ],
    );
  }
}
