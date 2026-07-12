import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/scrap_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewScrapScreen extends ConsumerStatefulWidget {
  final ScrapEntity? scrapToEdit;

  const NewScrapScreen({super.key, this.scrapToEdit});

  @override
  ConsumerState<NewScrapScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewScrapScreen> {
  final _formKey = GlobalKey<FormState>();

  RawMaterialEntity? _selectedMaterial;
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');

  bool get _isEditing => widget.scrapToEdit != null;

  @override
  void initState() {
    super.initState();
    _widthController.addListener(() => setState(() {}));
    _heightController.addListener(() => setState(() {}));

    final scrap = widget.scrapToEdit;
    if (scrap != null) {
      _widthController.text = scrap.width.toString();
      _heightController.text = scrap.height.toString();
      _qtyController.text = scrap.stock.toString();
      _selectedMaterial = scrap.rawMaterial;
    }
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _saveScrap() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMaterial == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar la materia prima')),
        );
        return;
      }

      final w =
          double.tryParse(_widthController.text.replaceAll(',', '.')) ?? 0;
      final h =
          double.tryParse(_heightController.text.replaceAll(',', '.')) ?? 0;
      final stock = int.tryParse(_qtyController.text) ?? 1;

      if (w <= 0 || h <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las dimensiones deben ser mayores a cero'),
          ),
        );
        return;
      }

      final scrap = ScrapEntity(
        id: widget.scrapToEdit?.id,
        width: w,
        height: h,
        stock: stock,
        rawMaterial: _selectedMaterial!,
      );

      final notifier = ref.read(scrapProvider.notifier);
      final future = _isEditing
          ? notifier.updateScrap(scrap)
          : notifier.addScrap(scrap);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing ? 'Retazo actualizado' : 'Retazo guardado',
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
    final rawMaterialsState = ref.watch(rawMaterialProvider);

    return FormScreenLayout(
      title: _isEditing ? "Editar Retazo" : "Registrar Retazo",
      subtitle: _isEditing
          ? "Modifique los detalles del retazo seleccionado"
          : "Ingrese los detalles del nuevo retazo para el inventario.",
      returnLabel: "Volver al Inventario",
      saveLabel: _isEditing ? "Guardar Cambios" : "Guardar Retazo",
      maxWidth: 1200,
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
                width: constraints.maxWidth,

                child: rawMaterialsState.when(
                  data: (materials) {
                    return LabeledDropdown(
                      label: "Material",
                      value: _selectedMaterial,
                      items: materials
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                '${m.description} (${m.sku})',
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      hint: "Seleccione un material",
                      onChanged: (val) =>
                          setState(() => _selectedMaterial = val),
                      validator: (value) => value == null ? 'Requerido' : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error al cargar materiales: $e'),
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text(
                  "Dimensiones",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _widthController,
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  label: "Ancho",
                  hint: "20",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _heightController,
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  label: "Alto",
                  hint: "10",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: _qtyController,
                  inputType: TextInputType.number,
                  label: "Cantidad",
                  hint: "1",
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: Column(
        children: [
          Container(
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
                    final double w =
                        double.tryParse(
                          _widthController.text.replaceAll(',', '.'),
                        ) ??
                        0;
                    final double h =
                        double.tryParse(
                          _heightController.text.replaceAll(',', '.'),
                        ) ??
                        0;

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
                                color: hasValues
                                    ? Colors.blue
                                    : Colors.blueGrey,
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
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Política de Retazos",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Solo registre piezas mayores a 10x10cm. Las piezas más pequeñas deben descartarse.",
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onReturn: () {
        context.go('inventory');
      },
      onSave: _saveScrap,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
