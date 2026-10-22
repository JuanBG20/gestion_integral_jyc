import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/expense_payment_status.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_date_picker.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_segment_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/utils/price_calculator.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_category_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/add_expense_material_dialog.dart';
import 'package:go_router/go_router.dart';

class NewExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseEntity? expenseToEdit;

  const NewExpenseScreen({super.key, this.expenseToEdit});

  @override
  ConsumerState<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends ConsumerState<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  ExpenseCategoryEntity? _selectedCategory;
  ExpensePaymentStatus _paymentStatus = ExpensePaymentStatus.pagado;

  DateTime _emissionDate = DateTime.now();
  DateTime? _dueDate;

  List<ExpenseRawMaterialEntity> _materials = [];

  bool get _isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();

    final expense = widget.expenseToEdit;
    if (expense != null) {
      _descController.text = expense.description;
      _amountController.text = expense.amount?.toStringAsFixed(2) ?? '';
      _selectedCategory = expense.category;
      _paymentStatus = expense.paymentStatus;
      _emissionDate = expense.emissionDate;
      _dueDate = expense.dueDate;
      _materials = List.from(expense.rawMaterialItems);
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openAddMaterialDialog() async {
    final result = await showDialog<ExpenseRawMaterialEntity>(
      context: context,
      builder: (context) => const AddExpenseMaterialDialog(),
    );

    if (result != null) {
      setState(() {
        _materials.add(result);
        final currentTotal =
            double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
        final lineTotal = result.quantity * (result.unitPrice ?? 0);
        _amountController.text = (currentTotal + lineTotal).toStringAsFixed(2);
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione una categoría')),
        );
        return;
      }

      final amount =
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

      final expense = ExpenseEntity(
        id: widget.expenseToEdit?.id,
        description: _descController.text.trim(),
        category: _selectedCategory!,
        amount: amount,
        paymentStatus: _paymentStatus,
        emissionDate: _emissionDate,
        dueDate: _dueDate,
        paymentDate: _paymentStatus == ExpensePaymentStatus.pagado
            ? _emissionDate
            : null,
        rawMaterialItems: _materials,
      );

      final notifier = ref.read(expenseProvider.notifier);
      final future = _isEditing
          ? notifier.updateExpense(expense)
          : notifier.createExpense(expense);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'Gasto actualizado'
                      : 'Gasto registrado exitosamente',
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

    return FormScreenLayout(
      title: _isEditing ? "Editar Gasto" : "Registrar Nuevo Gasto",
      subtitle: "Registrá egresos del taller",
      returnLabel: "Volver a Gastos",
      saveLabel: _isEditing ? "Guardar Cambios" : "Guardar Gasto",
      maxWidth: 800,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: ((context, constraints) {
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
                child: LabeledTextField(
                  controller: _descController,
                  label: "Descripción del Gasto",
                  hint: "Ej. Compra filamentos PLA / Mantenimiento extrusor...",
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
                child: LabeledTextField(
                  controller: _amountController,
                  label: "Monto Total",
                  hint: "0.00",
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: LabeledSegmentButton<ExpensePaymentStatus>(
                  label: "Estado del Pago",
                  groupValue: _paymentStatus,
                  onChanged: (val) {
                    setState(() {
                      _paymentStatus = val;
                    });
                  },

                  leftTitle: "Pagado",
                  leftIcon: Icons.check_circle_outline,
                  leftValue: ExpensePaymentStatus.pagado,

                  rightTitle: "Pendiente",
                  rightIcon: Icons.schedule,
                  rightValue: ExpensePaymentStatus.pendiente,
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: LabeledDatePicker(
                  label: "Fecha de Emisión",
                  hint: "Seleccione una fecha...",
                  onChanged: (picked) {
                    setState(() {
                      _emissionDate = picked;
                    });
                  },
                  value: _emissionDate,
                ),
              ),

              SizedBox(
                width: halfWidth,
                child: LabeledDatePicker(
                  label: "Fecha de Vencimiento",
                  hint: "Seleccione una fecha...",
                  onChanged: (picked) {
                    setState(() {
                      _dueDate = picked;
                    });
                  },
                  value: _dueDate,
                ),
              ),

              Divider(color: AppColors.outline),

              // Asociar a Materia Prima
              SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Detalle de Insumos",
                          style: context.textTheme.titleMedium,
                        ),

                        TextButton.icon(
                          onPressed: _openAddMaterialDialog,
                          label: const Text("Añadir Insumo"),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (_materials.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.onBackground.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.outline),
                        ),

                        child: Text(
                          "No hay insumos asociados a esta compra.",
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _materials.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _materials[index];
                          final lineTotal =
                              item.quantity * (item.unitPrice ?? 0);
                          final isGrams =
                              item.rawMaterial.measurementUnit ==
                              MeasurementUnit.gramos;
                          final unitName = isGrams
                              ? 'Kg'
                              : item.rawMaterial.measurementUnit.name;

                          final displayUnitPrice =
                              PriceCalculator.toDisplayPrice(
                                item.unitPrice ?? 0,
                                item.rawMaterial.measurementUnit,
                              );

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.outline),
                              borderRadius: BorderRadius.circular(4),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        item.rawMaterial.description,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      Text(
                                        'Cantidad: ${item.quantity} ${item.rawMaterial.measurementUnit.name}',
                                        style: context.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [
                                    Text(
                                      "\$${lineTotal.toStringAsFixed(2)}",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    Text(
                                      "Costo unit.: \$${displayUnitPrice.toStringAsFixed(2)} / $unitName",
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 8),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _materials.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  tooltip: 'Eliminar ítem',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      onReturn: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/expenses');
        }
      },
      onSave: _saveExpense,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
