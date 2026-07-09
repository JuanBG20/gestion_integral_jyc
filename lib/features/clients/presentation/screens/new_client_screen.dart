import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewClientScreen extends StatefulWidget {
  const NewClientScreen({super.key});

  @override
  State<NewClientScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewClientScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Cliente",
      subtitle:
          "Ingrese los detalles para crear un nuevo cliente. Los campos obligatorios están marcados con un asterisco (*).",
      returnLabel: "Volver a Clientes",
      saveLabel: "Guardar Cliente",
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
                  label: "Nombre (*)",
                  hint: "Juan Bautista",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Apellido (*)",
                  hint: "Galván",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Tido de Documento",
                  hint: "DNI",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Número de Documento",
                  hint: "46427900",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Contacto", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Teléfono",
                  hint: "2364509648",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Email",
                  hint: "juanbgalvan.19@gmail.com",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Dirección", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Calle",
                  hint: "Tucumán",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Número",
                  hint: "199",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Localidad",
                  hint: "Arribeños",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Provincia",
                  hint: "Buenos Aires",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Piso",
                  hint: "5",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Departamento",
                  hint: "A",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Notas Adicionales",
                  hint: "Cualquier detalle del cliente...",
                ),
              ),
            ],
          );
        },
      ),

      onReturn: () {
        context.go('/clients');
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
