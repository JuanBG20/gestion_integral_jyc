import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class NewRawMaterialScreen extends StatefulWidget {
  const NewRawMaterialScreen({super.key});

  @override
  State<NewRawMaterialScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewRawMaterialScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Align(
        alignment: Alignment.topCenter,

        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: _formKey,

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
                              "Registrar Materia Prima",
                              style: context.textTheme.titleLarge,
                            ),
                            Text(
                              "Ingrese los detalles del nuevo material para el inventario.",
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      TextButton.icon(
                        onPressed: () {},
                        label: Text("Volver al Inventario"),
                        icon: Icon(Icons.arrow_back),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(color: AppColors.outline),
                      borderRadius: BorderRadius.circular(4),
                    ),

                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isDesktop = constraints.maxWidth > 600;
                        final double itemWidth = isDesktop
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

                              child: Text(
                                "Stock",
                                style: context.textTheme.titleMedium,
                              ),
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

                            Divider(color: AppColors.outline),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text("Cancelar"),
                                ),

                                const SizedBox(width: 16),

                                ElevatedButton.icon(
                                  onPressed: () {},
                                  label: Text("Guardar Material"),
                                  icon: Icon(Icons.save_outlined),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
