import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/measurement_unit.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewRawMaterialScreen extends ConsumerStatefulWidget {
  final RawMaterialEntity? rawMaterialToEdit;

  const NewRawMaterialScreen({super.key, this.rawMaterialToEdit});

  @override
  ConsumerState<NewRawMaterialScreen> createState() =>
      _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewRawMaterialScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descController = TextEditingController();
  final _skuController = TextEditingController();
  final _catController = TextEditingController();
  final _subcatController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();

  MeasurementUnit _selectedUnit = MeasurementUnit.unidad;

  bool get _isEditing => widget.rawMaterialToEdit != null;

  @override
  void initState() {
    super.initState();

    final material = widget.rawMaterialToEdit;
    if (material != null) {
      _descController.text = material.description;
      _skuController.text = material.sku;
      _catController.text = material.category;
      _subcatController.text = material.subcategory;
      _stockController.text = material.stock.toString();
      _minStockController.text = material.minStock.toString();
      _selectedUnit = material.measurementUnit;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _skuController.dispose();
    _catController.dispose();
    _subcatController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  void _saveMaterial() {
    if (_formKey.currentState!.validate()) {
      final material = RawMaterialEntity(
        id: widget.rawMaterialToEdit?.id,
        description: _descController.text.trim(),
        sku: _skuController.text.trim(),
        category: _catController.text.trim(),
        subcategory: _subcatController.text.trim(),
        stock: double.tryParse(_stockController.text.trim()) ?? 0,
        minStock: double.tryParse(_minStockController.text.trim()) ?? 0,
        measurementUnit: _selectedUnit,
      );

      final notifier = ref.read(rawMaterialProvider.notifier);
      final future = _isEditing
          ? notifier.updateRawMaterial(material)
          : notifier.addRawMaterial(material);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'Materia Prima actualizada'
                      : 'Materia Prima guardada',
                ),
              ),
            );
            context.go('/inventory');
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
    return FormScreenLayout(
      title: _isEditing ? "Editar Materia Prima" : "Registrar Materia Prima",
      subtitle: _isEditing
          ? "Modifique los detalles del material seleccionado"
          : "Ingrese los detalles del nuevo material para el inventario",
      returnLabel: "Volver al Inventario",
      saveLabel: _isEditing ? "Guardar Cambios" : "Guardar Material",
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 500;
          final double itemWidth = isWide
              ? (constraints.maxWidth - 24) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 24,
            runSpacing: 24,

            children: [
              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _descController,
                  label: "Descripción",
                  hint: "PLA Negro Hellbot",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _skuController,
                  label: "SKU",
                  hint: "MAT-PLA-HEL-001",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _catController,
                  label: "Categoría",
                  hint: "Impresión 3D",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _subcatController,
                  label: "Subcategoría",
                  hint: "PLA",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Stock", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _stockController,
                  label: "Stock Inicial",
                  hint: "0",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _minStockController,
                  label: "Stock Mínimo",
                  hint: "10",
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<MeasurementUnit>(
                  label: "Unidad de Medida",
                  value: _selectedUnit,
                  hint: "Seleccione una unidad...",
                  items: MeasurementUnit.values
                      .map(
                        (u) => DropdownMenuItem(value: u, child: Text(u.label)),
                      )
                      .toList(),
                  onChanged: (val) => setState(
                    () => _selectedUnit = val ?? MeasurementUnit.unidad,
                  ),
                ),
              ),
            ],
          );
        },
      ),

      onReturn: () {
        context.go('/inventory');
      },
      onSave: _saveMaterial,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
