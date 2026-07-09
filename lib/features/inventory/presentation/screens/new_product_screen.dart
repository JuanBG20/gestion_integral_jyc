import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/variants_table_section.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewProductScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Producto",
      subtitle: "Ingrese los detalles del nuevo producto para el inventario",
      returnLabel: "Volver al Inventario",
      saveLabel: "Guardar Producto",
      maxWidth: double.infinity,
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

                child: Text(
                  "Información Principal",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Descripción",
                  hint: "Cuadro Margaritas",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "SKU",
                  hint: "PRO-CMA-001",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Categoría",
                  hint: "Corte Láser",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Subcategoría",
                  hint: "Cuadros",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Precios", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Costo",
                  hint: "10000",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Venta",
                  hint: "20000",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: Text("Variantes", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: const VariantsTableSection(),
              ),
            ],
          );
        },
      ),

      onReturn: () {
        context.go('/inventory');
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
