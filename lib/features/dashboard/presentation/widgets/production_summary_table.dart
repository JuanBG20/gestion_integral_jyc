import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ProductionSummaryTable extends StatelessWidget {
  const ProductionSummaryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Resumen de Producción",
                style: context.textTheme.titleMedium,
              ),
              TextButton(onPressed: () {}, child: Text("Ver Todo")),
            ],
          ),

          // TODO: Tabla de producción
        ],
      ),
    );
  }
}
