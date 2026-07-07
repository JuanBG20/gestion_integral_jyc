import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        backgroundColor: AppColors.surface,

        body: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Inventario", style: context.textTheme.titleLarge),
              Text(
                "Gestión de productos terminados, materia prima y retazos.",
                style: context.textTheme.bodyLarge,
              ),

              const SizedBox(height: 8),

              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: AppColors.outline,

                tabs: const [
                  Tab(text: "Materia Prima"),
                  Tab(text: "Productos"),
                  Tab(text: "Retazos"),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabContainer(context),
                    _buildTabContainer(context),
                    _buildTabContainer(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContainer(BuildContext context) {
    final baseMate = BaseProductEntity(
      baseSku: 'PR-001',
      category: 'Impresión 3D',
      subcategory: 'Mates',
      description: 'Mate Pelota de Fútbol',
    );

    final baseCuadro = BaseProductEntity(
      baseSku: 'CL-002',
      category: 'Corte Láser',
      subcategory: 'Decoración',
      description: 'Cuadro Árbol de la Vida',
    );

    final List<ProductGroupUi> mockInventory = [
      ProductGroupUi(
        baseProduct: baseMate,
        variants: [
          VariantProductEntity(
            sku: 'PR-001-BCO',
            stock: 12,
            costPrice: 1500.0,
            salePrice: 4500.0,
            color: 'Blanco',
            baseProduct: baseMate,
            manufacturingRecipe: [], // Vacío por ahora
          ),
          VariantProductEntity(
            sku: 'PR-001-NG',
            stock: 3, // Stock bajo para probar la alerta
            costPrice: 1500.0,
            salePrice: 4500.0,
            color: 'Negro',
            baseProduct: baseMate,
            manufacturingRecipe: [],
          ),
        ],
      ),
      ProductGroupUi(
        baseProduct: baseCuadro,
        variants: [
          VariantProductEntity(
            sku: 'CL-002-MDF3',
            stock: 25,
            costPrice: 2200.0,
            salePrice: 6500.0,
            color: 'MDF Natural',
            size: '40x40cm',
            baseProduct: baseCuadro,
            manufacturingRecipe: [],
          ),
        ],
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          // Cabecera
          _buildTableHeader(context),

          ...mockInventory.map(
            (product) => _buildExpandableTableRow(context, product: product),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final headerTheme = context.textTheme.bodyMedium?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 60),
      decoration: BoxDecoration(color: AppColors.surface),

      child: Row(
        children: [
          Expanded(flex: 2, child: Text("SKU", style: headerTheme)),
          Expanded(flex: 3, child: Text("Descripción", style: headerTheme)),
          Expanded(flex: 1, child: Text("Stock", style: headerTheme)),
          Expanded(
            flex: 3,
            child: Text("Categoría > Subcategoría", style: headerTheme),
          ),
          Expanded(flex: 2, child: Text("Precio Costo", style: headerTheme)),
          Expanded(flex: 2, child: Text("Precio Venta", style: headerTheme)),
        ],
      ),
    );
  }

  Widget _buildExpandableTableRow(
    BuildContext context, {
    required ProductGroupUi product,
  }) {
    final base = product.baseProduct;

    return ExpansionTile(
      showTrailingIcon: false,
      tilePadding: const EdgeInsets.only(left: 24, right: 24),

      leading: Icon(Icons.keyboard_arrow_down),

      title: Row(
        children: [
          Expanded(flex: 2, child: Text(base.baseSku)),
          Expanded(flex: 3, child: Text(base.description)),
          Expanded(flex: 1, child: Text('${product.totalStock}u. Total')),
          Expanded(flex: 3, child: Text(base.fullCategory)),
          Expanded(flex: 2, child: Text("")),
          Expanded(flex: 2, child: Text("")),
        ],
      ),

      children: product.variants
          .map((variant) => _buildTableRow(context, variant: variant))
          .toList(),
    );
  }

  Widget _buildTableRow(
    BuildContext context, {
    required VariantProductEntity variant,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 60, right: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(variant.sku),
            ),
          ),
          Expanded(flex: 3, child: Text('${variant.color} - ${variant.size}')),
          Expanded(flex: 1, child: Text(variant.stock.toString())),
          Expanded(flex: 3, child: Text("")),
          Expanded(
            flex: 2,
            child: Text('\$${variant.costPrice.toStringAsFixed(2)}'),
          ),
          Expanded(
            flex: 2,
            child: Text('\$${variant.salePrice.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {},
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'update', child: Text('Actualizar Stock')),
        const PopupMenuItem(value: 'edit', child: Text('Modificar')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }
}
