import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/scrap_provider.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,

      child: Builder(
        builder: (BuildContext tabContext) {
          return Scaffold(
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
                          Text(
                            "Inventario",
                            style: context.textTheme.titleLarge,
                          ),
                          Text(
                            "Gestión de productos terminados, materia prima y retazos.",
                            style: context.textTheme.bodyLarge,
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          final currentIndex = DefaultTabController.of(
                            tabContext,
                          ).index;

                          switch (currentIndex) {
                            case 0:
                              tabContext.go('/inventory/new-material');
                              break;
                            case 1:
                              tabContext.go('/inventory/new-product');
                              break;
                            case 2:
                              tabContext.go('/inventory/new-scrap');
                              break;
                          }
                        },
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
                        _buildRawMaterialsTab(context, ref),
                        _buildProductsTab(context, ref),
                        _buildScrapsTab(context, ref),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRawMaterialsTab(BuildContext context, WidgetRef ref) {
    final rawMaterialsState = ref.watch(rawMaterialProvider);

    return rawMaterialsState.when(
      data: (rawMaterials) {
        if (rawMaterials.isEmpty) {
          return const Center(child: Text("No hay materia primar registrada."));
        }

        return AppTableShell(
          header: const AppTableHeader(columns: _rawMaterialColumns),
          rows: rawMaterials
              .map(
                (mp) => AppTableRow(
                  cells: [
                    AppTableCell.text(mp.sku, flex: 2),
                    AppTableCell.text(mp.description, flex: 3),
                    AppTableCell.text(mp.stock.toString(), flex: 1),
                    AppTableCell.text(mp.minStock.toString(), flex: 2),
                    AppTableCell.text(mp.fullCategory, flex: 3),
                  ],
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildProductsTab(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(inventoryProductsProvider);

    return productsState.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No hay productos registrada."));
        }

        return AppTableShell(
          header: const AppTableHeader(
            columns: _productColumns,
            padding: EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 60),
          ),
          rows: products
              .map(
                (product) =>
                    _buildExpandableTableRow(context, product: product),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildScrapsTab(BuildContext context, WidgetRef ref) {
    final scrapsState = ref.watch(scrapProvider);

    return scrapsState.when(
      data: (scraps) {
        if (scraps.isEmpty) {
          return const Center(child: Text("No hay retazos registrados."));
        }

        return AppTableShell(
          header: const AppTableHeader(columns: _scrapColumns),
          rows: scraps
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error al cargar retazos: $e")),
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
