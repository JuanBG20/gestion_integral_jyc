import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';

class NewRawMaterialScreen extends StatefulWidget {
  const NewRawMaterialScreen({super.key});

  @override
  State<NewRawMaterialScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewRawMaterialScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Materia Prima",
      subtitle: "Ingrese los detalles del nuevo material para el inventario",
      returnLabel: "Volver al Inventario",
      saveLabel: "Guardar Material",
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
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Descripción",
                  hint: "PLA Negro Hellbot",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "SKU",
                  hint: "MAT-PLA-HEL-001",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Categoría",
                  hint: "Impresión 3D",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Subcategoría",
                  hint: "PLA",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Stock", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Stock Inicial",
                  hint: "0",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Stock Mínimo",
                  hint: "10",
                ),
              ),
            ],
          );
        },
      ),

      onReturn: () {},
      onSave: () {},
      onCancel: () {},
    );
  }
}
