import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

void showStockDialog({
  required BuildContext context,
  required String title,
  required bool isProduct,
  required bool isAdmin,
  required void Function(double delta, bool deductMp) onConfirm,
}) {
  double delta = 0;
  bool deductMp = true;
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            title: Text(title, style: context.textTheme.titleMedium),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Ingrese la cantidad a sumar o restar.",
                  style: context.textTheme.bodySmall,
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Cantidad (Ej: 5 o -2)",
                    hintText: "0",
                  ),
                  onChanged: (val) {
                    setState(() {
                      delta = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                    });
                  },
                ),

                if (isProduct && delta > 0 && isAdmin) ...[
                  const SizedBox(height: 16),

                  CheckboxListTile(
                    value: deductMp,
                    onChanged: (val) => setState(() => deductMp = val ?? true),
                    title: Text(
                      "Descontar Materia Prima",
                      style: context.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      "Según la receta asociada a este producto",
                      style: context.textTheme.bodySmall,
                    ),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ],
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),

                child: const Text('Cancelar'),
              ),

              ElevatedButton(
                onPressed: delta == 0
                    ? null
                    : () {
                        onConfirm(delta, deductMp);
                        Navigator.pop(context);
                      },

                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    },
  );
}
