import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_date_picker.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';

class ConfirmPaymentDialog extends ConsumerStatefulWidget {
  final ExpenseEntity expense;

  const ConfirmPaymentDialog({super.key, required this.expense});

  @override
  ConsumerState<ConfirmPaymentDialog> createState() =>
      _ConfirmPaymentDialogState();
}

class _ConfirmPaymentDialogState extends ConsumerState<ConfirmPaymentDialog> {
  final _amountController = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense.amount != null && widget.expense.amount! > 0) {
      _amountController.text = widget.expense.amount!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    final finalAmount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

    if (finalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresá un monto válido mayor a 0.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(expenseProvider.notifier)
          .markAsPaid(
            widget.expense.id!,
            finalAmount: finalAmount,
            paymentDate: _paymentDate,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago registrado exitosamente.')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al registrar pago: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text("Registrar Pago", style: context.textTheme.titleMedium),

      content: SizedBox(
        width: 400,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Estás por marcar como pagado el gasto: ${widget.expense.description}.",
              style: context.textTheme.bodySmall,
            ),

            const SizedBox(height: 16),

            LabeledTextField(
              controller: _amountController,
              label: "Monto Final",
              hint: "0.00",
              prefixIcon: const Icon(Icons.attach_money, size: 18),
              inputType: const TextInputType.numberWithOptions(decimal: true),
              readOnly: widget.expense.template == null ? true : false,
            ),

            const SizedBox(height: 16),

            LabeledDatePicker(
              label: "Fecha de Pago",
              value: _paymentDate,
              onChanged: (date) => setState(() => _paymentDate = date),
              hint: 'Seleccione una fecha...',
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),

        ElevatedButton.icon(
          onPressed: _isLoading ? null : _confirmPayment,
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.check),
          label: const Text('Confirmar Pago'),
        ),
      ],
    );
  }
}
