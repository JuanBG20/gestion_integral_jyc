import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class VariableTemplateInfoBanner extends StatelessWidget {
  const VariableTemplateInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),

      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Al ser un monto variable (ej. Luz, Gas), el gasto se generará con importe \$0. Deberás ingresar el monto real al momento de registrar su pago.",
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
