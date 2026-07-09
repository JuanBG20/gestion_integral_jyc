import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/models/sale_mock_data.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
import 'package:go_router/go_router.dart';

class SalesScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                      Expanded(flex: 6, child: _buildLeftColumn(context)),

                      const SizedBox(width: 24),

                      Expanded(flex: 4, child: _buildRightColumn(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context),
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

  Widget _buildLeftColumn(BuildContext context) {
    final ventas = [
      const SaleMockData(
        id: 'V-1042',
        client: 'Caja',
        date: '24/10/2023',
        method: 'Efectivo',
        amount: 15400.00,
      ),
      const SaleMockData(
        id: 'V-1041',
        client: 'Martín Rodríguez',
        date: '24/10/2023',
        method: 'Transferencia',
        amount: 42000.00,
        hasCae: true,
      ),
      const SaleMockData(
        id: 'V-1040',
        client: 'Genérico',
        date: '23/10/2023',
        method: 'Mercado Pago QR',
        amount: 8500.00,
      ),
    ];

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

              AppTableShell(
                shrinkWrap: true,
                minWidth: 600,
                header: const AppTableHeader(
                  columns: _salesColumns,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  trailingWidth: 16,
                ),
                rows: ventas
                    .map((venta) => _buildSaleRow(context, venta: venta))
                    .toList(),
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

          const PaymentMethodSelector(),

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

  Widget _buildSaleRow(BuildContext context, {required SaleMockData venta}) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailingWidth: 16,
      cells: [
        AppTableCell.text(
          venta.id,
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          venta.client,
          flex: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell.text(
          venta.date,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          venta.method,
          flex: 2,
          style: context.textTheme.bodySmall,
        ),
        AppTableCell.text(
          '\$${venta.amount.toStringAsFixed(2)}',
          flex: 2,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppTableCell(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,

            child: _buildArcaIndicator(context, hasCae: venta.hasCae),
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
