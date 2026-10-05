import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/providers/report_provider.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Mantenimiento';
  bool _isLoading = false;

  final _categories = [
    'Mantenimiento',
    'Servicios',
    'Insumos',
    'Taller',
    'Impuestos',
    'Suscripciones',
    'Otros',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final amount =
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

      final expense = ExpenseEntity(
        description: _descController.text.trim(),
        category: _selectedCategory,
        amount: amount,
        date: DateTime.now(),
      );

      await ref.read(expenseProvider.notifier).addExpense(expense);

      ref.invalidate(reportMetricsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gasto registrado exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text("Registrar Gasto", style: context.textTheme.titleMedium),

      content: Form(
        key: _formKey,

        child: SizedBox(
          width: 400,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              LabeledTextField(
                controller: _descController,
                label: "Descripción",
                hint: "Ej. Compra de herramientas",
                validator: (val) =>
                    val == null || val.isEmpty ? 'Requerido' : null,
              ),

              const SizedBox(height: 16),

              LabeledDropdown<String>(
                label: "Categoría",
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),

              const SizedBox(height: 16),

              LabeledTextField(
                controller: _amountController,
                label: "Monto",
                hint: "0.00",
                inputType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.attach_money),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),

        ElevatedButton.icon(
          onPressed: _isLoading ? null : _save,
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
          label: const Text('Registrar Salida'),
        ),
      ],
    );
  }
}
