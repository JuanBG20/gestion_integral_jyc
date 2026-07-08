import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';

class NewScrapScreen extends StatefulWidget {
  const NewScrapScreen({super.key});

  @override
  State<NewScrapScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewScrapScreen> {
  final _formKey = GlobalKey<FormState>();

  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _widthController.addListener(() => setState(() {}));
    _heightController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Retazo",
      subtitle: "Ingrese los detalles del nuevo retazo para el inventario.",
      returnLabel: "Volver al Inventario",
      saveLabel: "Guardar Retazo",
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
                  label: "Material",
                  hint: "MDF 3mm",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text(
                  "Dimensiones",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _widthController,
                  label: "Ancho",
                  hint: "20",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _heightController,
                  label: "Alto",
                  hint: "10",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Cantidad",
                  hint: "1",
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Previsualización de Proporción",
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                Builder(
                  builder: (context) {
                    final double w =
                        double.tryParse(
                          _widthController.text.replaceAll(',', '.'),
                        ) ??
                        0;
                    final double h =
                        double.tryParse(
                          _heightController.text.replaceAll(',', '.'),
                        ) ??
                        0;

                    final bool hasValues = w > 0 && h > 0;
                    final double currentRatio = hasValues ? (w / h) : 1.0;
                    final String label = hasValues
                        ? "${w.toStringAsFixed(0)}x${h.toStringAsFixed(0)}"
                        : "Dimensión";

                    return SizedBox(
                      height: 160,
                      width: double.infinity,

                      child: Center(
                        child: AspectRatio(
                          aspectRatio: currentRatio,

                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // TODO: Dotted Border
                              border: Border.all(
                                color: hasValues
                                    ? AppColors.primary
                                    : AppColors.outline,
                                width: 2,
                              ),
                            ),

                            child: Text(
                              label,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: hasValues
                                    ? Colors.blue
                                    : Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),

                Divider(color: AppColors.outline),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    "Representación visual escalada al tamaño disponible.",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Política de Retazos",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Solo registre piezas mayores a 10x10cm. Las piezas más pequeñas deben descartarse.",
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onReturn: () {},
      onSave: () {},
      onCancel: () {},
    );
  }
}
