import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ProportionPreview extends StatelessWidget {
  final String width;
  final String height;

  const ProportionPreview({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
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
              final double w = double.tryParse(width.replaceAll(',', '.')) ?? 0;
              final double h =
                  double.tryParse(height.replaceAll(',', '.')) ?? 0;

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
                          color: hasValues ? Colors.blue : Colors.blueGrey,
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
    );
  }
}
