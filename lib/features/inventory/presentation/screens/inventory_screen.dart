import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  static const _rawMaterialColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Stock Mínimo", flex: 2),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
  ];

  static const _productColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
  ];

  static const _scrapColumns = [
    AppTableColumn(label: "Materia Prima", flex: 4),
    AppTableColumn(label: "Ancho", flex: 2),
    AppTableColumn(label: "Alto", flex: 2),
    AppTableColumn(label: "Stock", flex: 1),
  ];

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

    return AppTableShell(
      header: const AppTableHeader(columns: _rawMaterialColumns),
      rows: materiasPrimas
          .map(
            (mp) => AppTableRow(
              cells: [
                AppTableCell.text(mp.sku, flex: 2),
                AppTableCell.text(mp.description, flex: 3),
                AppTableCell.text(mp.stock.toString(), flex: 1),
                AppTableCell.text(mp.minStock.toString(), flex: 2),
                AppTableCell.text(
                  '${mp.category} > ${mp.subcategory}',
                  flex: 3,
                ),
              ],
            ),
          )
          .toList(),
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

    return AppTableShell(
      header: const AppTableHeader(
        columns: _productColumns,
        leadingPadding: 60,
      ),
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

    return AppTableShell(
      header: const AppTableHeader(columns: _scrapColumns),
      rows: retazos
          .map(
            (scrap) => AppTableRow(
              cells: [
                AppTableCell.text(scrap.rawMaterial.description, flex: 4),
                AppTableCell.text(
                  '${scrap.width.toStringAsFixed(1)} cm',
                  flex: 2,
                ),
                AppTableCell.text(
                  '${scrap.height.toStringAsFixed(1)} cm',
                  flex: 2,
                ),
                AppTableCell.text(scrap.stock.toString(), flex: 1),
              ],
            ),
          )
          .toList(),
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
          .map(
            (variant) => AppTableRow(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 60,
                right: 24,
              ),
              background: AppColors.surface,
              cells: [
                AppTableCell.text(variant.sku, flex: 2),
                AppTableCell.text(
                  [
                    variant.color,
                    variant.size,
                  ].where((e) => e != null && e.isNotEmpty).join(' - '),
                  flex: 3,
                ),
                AppTableCell.text(variant.stock.toString(), flex: 1),
                AppTableCell.text("", flex: 3),
                AppTableCell.text(
                  '\$${variant.costPrice.toStringAsFixed(2)}',
                  flex: 2,
                ),
                AppTableCell.text(
                  '\$${variant.salePrice.toStringAsFixed(2)}',
                  flex: 2,
                ),
              ],
            ),
          )
          .toList(),
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
