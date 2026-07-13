import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';

class QuickSale extends StatelessWidget {
  const QuickSale({super.key});

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
          Text("Venta Rápida", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Cliente",
            hint: "Venta en caja",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Producto",
            hint: "Producto Genérico",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Material",
            hint: "PLA",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Consumo (g/cm2)",
            hint: "150",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: TextEditingController(),
            label: "Monto Final",
            hint: "0.00",
          ),

          const SizedBox(height: 16),

          PaymentMethodSelector(onMethodChanged: (PaymentMethod value) {}),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {},
              child: Text("Registrar Venta"),
            ),
          ),
        ],
      ),
    );
  }
}
