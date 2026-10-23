import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/expense_amount_types.dart';
import 'package:gestion_integral_jyc/core/enums/expense_frequencies.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_segment_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/templates/variable_template_info_banner.dart';
import 'package:go_router/go_router.dart';

class NewExpenseTemplateScreen extends ConsumerStatefulWidget {
  final ExpenseTemplateEntity? templateToEdit;

  const NewExpenseTemplateScreen({super.key, this.templateToEdit});

  @override
  ConsumerState<NewExpenseTemplateScreen> createState() =>
      _NewExpenseTemplateScreenState();
}

class _NewExpenseTemplateScreenState
    extends ConsumerState<NewExpenseTemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDayController = TextEditingController();

  ExpenseCategoryEntity? _selectedCategory;
  ExpenseFrequencies _selectedFrequency = ExpenseFrequencies.mensual;
  ExpenseAmountTypes _amountType = ExpenseAmountTypes.fijo;
  bool _isActive = true;

  bool get _isEditing => widget.templateToEdit != null;

  @override
  void initState() {
    super.initState();
    final template = widget.templateToEdit;
    if (template != null) {
      _descController.text = template.description;
      _amountController.text = template.amount?.toStringAsFixed(2) ?? '';
      _dueDayController.text = template.dueDay.toString();
      _selectedCategory = template.category;
      _selectedFrequency = template.frequency;
      _amountType = template.amountType;
      _isActive = template.isActive;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione una categoría')),
        );
        return;
      }

      final dueDay = int.tryParse(_dueDayController.text) ?? 1;
      if (dueDay < 1 || dueDay > 31) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El día de vencimiento debe estar entre 1 y 31'),
          ),
        );
        return;
      }

      double? finalAmount;
      if (_amountType == ExpenseAmountTypes.fijo) {
        finalAmount =
            double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
        if (finalAmount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ingrese un monto válido para el gasto fijo'),
            ),
          );
          return;
        }
      }

      final template = ExpenseTemplateEntity(
        id: widget.templateToEdit?.id,
        description: _descController.text.trim(),
        category: _selectedCategory!,
        frequency: _selectedFrequency,
        amountType: _amountType,
        amount: finalAmount,
        isActive: _isActive,
        dueDay: dueDay,
      );

      final notifier = ref.read(expenseTemplateProvider.notifier);
      final future = _isEditing
          ? notifier.updateTemplate(template)
          : notifier.createTemplate(template);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'Plantilla actualizada'
                      : 'Plantilla registrada exitosamente',
                ),
              ),
            );
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/expenses');
            }
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(expenseCategoryProvider);
    final isFijo = _amountType == ExpenseAmountTypes.fijo;

    return FormScreenLayout(
      title: _isEditing
          ? "Editar Plantilla Recurrente"
          : "Nueva Suscripción / Gasto Fijo",
      subtitle: "Definí reglas automáticas para tus gastos repetitivos.",
      returnLabel: "Volver a Gastos",
      saveLabel: _isEditing ? "Guardar Cambios" : "Crear Plantilla",
      maxWidth: 800,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 500;
          final double halfWidth = isWide
              ? (constraints.maxWidth - 24) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                child: SwitchListTile(
                  title: Text(
                    "Plantilla Activa",
                    style: context.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    "Si se desactiva, dejará de generar gastos automáticos.",
                    style: context.textTheme.bodySmall,
                  ),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: LabeledTextField(
                  controller: _descController,
                  label: "Descripción / Concepto",
                  hint:
                      "Ej. Alquiler del Taller, Suscripción Adobe, Luz EPEC...",
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: categoriesState.when(
                  data: (categories) => LabeledDropdown<ExpenseCategoryEntity>(
                    label: "Categoría de Egreso",
                    value: _selectedCategory,
                    hint: "Seleccione una categoría",
                    items: categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error: $e'),
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: LabeledDropdown<ExpenseFrequencies>(
                  label: "Frecuencia",
                  value: _selectedFrequency,
                  hint: "Seleccione...",
                  items: ExpenseFrequencies.values
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f.name[0].toUpperCase() + f.name.substring(1),
                          ), // Ej: "Mensual"
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(
                    () =>
                        _selectedFrequency = val ?? ExpenseFrequencies.mensual,
                  ),
                ),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: LabeledSegmentButton<ExpenseAmountTypes>(
                  label: "Tipo de Monto",
                  groupValue: _amountType,
                  onChanged: (val) {
                    setState(() {
                      _amountType = val;
                      if (val == ExpenseAmountTypes.variable) {
                        _amountController.clear();
                      }
                    });
                  },

                  leftTitle: "Fijo",
                  leftIcon: Icons.push_pin_outlined,
                  leftValue: ExpenseAmountTypes.fijo,

                  rightTitle: "Variable",
                  rightIcon: Icons.query_stats,
                  rightValue: ExpenseAmountTypes.variable,
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: LabeledTextField(
                  controller: _amountController,
                  label: "Monto (\$)",
                  hint: "0.00",
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  readOnly: !isFijo,
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: LabeledTextField(
                  controller: _dueDayController,
                  label: "Día de Vencimiento (1-31)",
                  hint: "Ej. 10",
                  inputType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Requerido';
                    final day = int.tryParse(val);
                    if (day == null || day < 1 || day > 31) {
                      return 'Día inválido';
                    }
                    return null;
                  },
                ),
              ),

              if (!isFijo)
                SizedBox(
                  width: constraints.maxWidth,
                  child: VariableTemplateInfoBanner(),
                ),
            ],
          );
        },
      ),
      onReturn: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/expenses');
        }
      },
      onSave: _saveTemplate,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
