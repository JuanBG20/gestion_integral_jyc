import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
import 'package:go_router/go_router.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Venta",
      subtitle: "Complete los detalles para registrar una nueva venta.",
      returnLabel: "Volver a Ventas",
      saveLabel: "Guardar Venta",
      maxWidth: 1200,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 500;
          final double itemWidth = isWide
              ? (constraints.maxWidth - 24) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 24,
            runSpacing: 24,

            children: [
              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Cliente",
                  hint: "Juan Bautista Galván",
                ),
              ),

              // TODO: Cliente Genérico
              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: Text(
                  "Agregar Producto",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Precio Unitario",
                  hint: "\$500",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Cantidad",
                  hint: "10",
                ),
              ),

              // TODO: Producto Genérico
              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Descripción",
                  hint: "Soporte para Celular",
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: Container(
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

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(4),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [Text("Soporte VESA"), Text("10u.")],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Text("\$1500"),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),

                        child: Text("Eliminar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Productos", style: context.textTheme.bodyMedium),
                Text("\$500", style: context.textTheme.bodyMedium),
              ],
            ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Total", style: context.textTheme.titleMedium),
                Text("\$500", style: context.textTheme.titleLarge),
              ],
            ),

            const SizedBox(height: 16),

            PaymentMethodSelector(),
          ],
        ),
      ),
      onReturn: () {
        context.go('/sales');
      },
      onSave: () {},
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
