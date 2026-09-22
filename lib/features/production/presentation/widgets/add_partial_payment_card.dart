import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';

class AddPartialPaymentCard extends StatefulWidget {
  final void Function(double amount, PaymentMethod method) onSave;

  const AddPartialPaymentCard({super.key, required this.onSave});

  @override
  State<AddPartialPaymentCard> createState() => _AddPartialPaymentCardState();
}

class _AddPartialPaymentCardState extends State<AddPartialPaymentCard> {
  late final TextEditingController _amountController;
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final amountText = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(amountText);

    if (amount != null && amount > 0) {
      widget.onSave(amount, _selectedMethod);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresá un monto válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Añadir Seña", style: context.textTheme.titleMedium),

          const SizedBox(height: 8),
          Divider(color: AppColors.outline),
          const SizedBox(height: 8),

          LabeledTextField(
            controller: _amountController,
            label: 'Monto',
            hint: '5000',
            inputType: TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.attach_money),
          ),

          const SizedBox(height: 24),

          PaymentMethodSelector(
            onMethodChanged: (method) {
              setState(() {
                _selectedMethod = method;
              });
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
