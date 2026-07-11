import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/variants_table_section.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewProductScreen extends ConsumerStatefulWidget {
  const NewProductScreen({super.key});

  @override
  ConsumerState<NewProductScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descController = TextEditingController();
  final _skuController = TextEditingController();
  final _catController = TextEditingController();
  final _subcatController = TextEditingController();

  List<VariantFormData> _currentVariants = [];

  @override
  void dispose() {
    _descController.dispose();
    _skuController.dispose();
    _catController.dispose();
    _subcatController.dispose();
    super.dispose();
  }

  void _saveFullProduct() {
    if (_formKey.currentState!.validate()) {
      if (_currentVariants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe agregar al menos una variante (Color/Tamaño)'),
          ),
        );
        return;
      }

      // Creamos la entidad base (Aún sin ID)
      final baseProduct = BaseProductEntity(
        baseSku: _skuController.text.trim(),
        category: _catController.text.trim(),
        subcategory: _subcatController.text.trim(),
        description: _descController.text.trim(),
      );

      // Mapeamos los datos del form a entidades
      final List<VariantProductEntity> variants = _currentVariants.map((v) {
        return VariantProductEntity(
          sku: v.sku,
          stock: v.stock,
          costPrice: v.costPrice,
          salePrice: v.salePrice,
          color: v.color.isNotEmpty ? v.color : null,
          size: v.size.isNotEmpty && v.size != '-' ? v.size : null,
          baseProduct: baseProduct,
          manufacturingRecipe: v.recipe,
        );
      }).toList();

      ref
          .read(inventoryProductsProvider.notifier)
          .addProductWithVariants(baseProduct, variants)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Producto, variantes y receta guardados exitosamente',
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
      title: "Registrar Producto",
      subtitle: "Ingrese los detalles del nuevo producto para el inventario",
      returnLabel: "Volver al Inventario",
      saveLabel: "Guardar Producto",
      maxWidth: double.infinity,
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

                child: Text(
                  "Información Principal",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _descController,
                  label: "Descripción",
                  hint: "Cuadro Margaritas",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _skuController,
                  label: "SKU",
                  hint: "PRO-CMA-001",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _catController,
                  label: "Categoría",
                  hint: "Corte Láser",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _subcatController,
                  label: "Subcategoría",
                  hint: "Cuadros",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text(
                  "Variantes, Precios y Recetas",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: VariantsTableSection(
                  onVariantsChanged: (variants) {
                    _currentVariants = variants;
                  },
                ),
              ),
            ],
          );
        },
      ),

      onReturn: () {
        context.go('/inventory');
      },
      onSave: _saveFullProduct,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
