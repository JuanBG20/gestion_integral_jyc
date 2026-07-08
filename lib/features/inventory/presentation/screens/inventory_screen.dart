import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Inventario", style: context.textTheme.titleLarge),
                      Text(
                        "Gestión de productos terminados, materia prima y retazos.",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),

                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Nuevo Item"),
                    icon: Icon(Icons.add),
                  ),
                ],
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
                    _buildRawMaterialsTab(context),
                    _buildProductsTab(context),
                    _buildScrapsTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableShell(
    BuildContext context, {
    required Widget header,
    required List<Widget> rows,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth = constraints.maxWidth > 1000
            ? constraints.maxWidth
            : 1000.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: SizedBox(
            width: tableWidth,

            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(4),
              ),

              child: ListView(children: [header, ...rows]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRawMaterialsTab(BuildContext context) {
    final materiasPrimas = [
      RawMaterialEntity(
        sku: 'MP-001',
        stock: 10,
        category: 'Impresión 3D',
        subcategory: 'PLA',
        description: 'Filamento Rojo',
        minStock: 20,
      ),
    ];

    return _buildTableShell(
      context,
      header: _buildRawMaterialsHeader(context),
      rows: [
        ...materiasPrimas.map(
          (mp) => _buildRawMaterialRow(context, material: mp),
        ),
      ],
    );
  }

  Widget _buildProductsTab(BuildContext context) {
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

    return _buildTableShell(
      context,
      header: _buildProductsHeader(context),
      rows: mockInventory
          .map((product) => _buildExpandableTableRow(context, product: product))
          .toList(),
    );
  }

  Widget _buildScrapsTab(BuildContext context) {
    final materiaPrima = RawMaterialEntity(
      sku: "MP-001",
      stock: 10,
      category: "Impresión3D",
      subcategory: "PLA",
      description: "PLA Rojo",
      minStock: 15,
    );
    final retazos = [
      ScrapEntity(height: 10, width: 20, rawMaterial: materiaPrima, stock: 1),
    ];

    return _buildTableShell(
      context,
      header: _buildScrapsHeader(context),
      rows: [...retazos.map((scrap) => _buildScrapRow(context, scrap: scrap))],
    );
  }

  Widget _buildRawMaterialsHeader(BuildContext context) {
    final headerTheme = context.textTheme.bodyMedium?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
    return Container(
      padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 24),
      decoration: BoxDecoration(color: AppColors.surface),

      child: Row(
        children: [
          Expanded(flex: 2, child: Text("SKU", style: headerTheme)),
          Expanded(flex: 3, child: Text("Descripción", style: headerTheme)),
          Expanded(flex: 1, child: Text("Stock", style: headerTheme)),
          Expanded(flex: 2, child: Text("Stock Mínimo", style: headerTheme)),
          Expanded(
            flex: 3,
            child: Text("Categoría > Subcategoría", style: headerTheme),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProductsHeader(BuildContext context) {
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

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildScrapsHeader(BuildContext context) {
    final headerTheme = context.textTheme.bodyMedium?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 24),
      decoration: BoxDecoration(color: AppColors.surface),

      child: Row(
        children: [
          Expanded(flex: 4, child: Text("Materia Prima", style: headerTheme)),
          Expanded(flex: 2, child: Text("Ancho", style: headerTheme)),
          Expanded(flex: 2, child: Text("Alto", style: headerTheme)),
          Expanded(flex: 1, child: Text("Stock", style: headerTheme)),

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRawMaterialRow(
    BuildContext context, {
    required RawMaterialEntity material,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),

      child: Row(
        children: [
          Expanded(flex: 2, child: Text(material.sku)),
          Expanded(flex: 3, child: Text(material.description)),
          Expanded(flex: 1, child: Text(material.stock.toString())),
          Expanded(flex: 2, child: Text(material.minStock.toString())),
          Expanded(
            flex: 3,
            child: Text('${material.category} > ${material.subcategory}'),
          ),

          const SizedBox(width: 40),
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

          SizedBox(width: 40, child: _buildActionMenu(context)),
        ],
      ),

      children: product.variants
          .map((variant) => _buildProductRow(context, variant: variant))
          .toList(),
    );
  }

  Widget _buildProductRow(
    BuildContext context, {
    required VariantProductEntity variant,
  }) {
    final variantSpecs = [
      variant.color,
      variant.size,
    ].where((element) => element != null && element.isNotEmpty).join(' - ');

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
          Expanded(flex: 3, child: Text(variantSpecs)),
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

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildScrapRow(BuildContext context, {required ScrapEntity scrap}) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),

      child: Row(
        children: [
          Expanded(flex: 4, child: Text(scrap.rawMaterial.description)),
          Expanded(
            flex: 2,
            child: Text('${scrap.width.toStringAsFixed(1)} cm'),
          ),
          Expanded(
            flex: 2,
            child: Text('${scrap.height.toStringAsFixed(1)} cm'),
          ),
          Expanded(flex: 1, child: Text(scrap.stock.toString())),

          const SizedBox(width: 40),
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
