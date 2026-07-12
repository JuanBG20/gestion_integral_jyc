import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/providers/auth_provider.dart';
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
    final isAdmin = ref.watch(isAdminProvider);

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
                        _buildRawMaterialsTab(context, ref, isAdmin),
                        _buildProductsTab(context, ref, isAdmin),
                        _buildScrapsTab(context, ref, isAdmin),
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

  Widget _buildRawMaterialsTab(
    BuildContext context,
    WidgetRef ref,
    bool isAdmin,
  ) {
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
                  trailingWidth: 40,
                  trailing: _buildActionMenu(
                    context,
                    isAdmin: isAdmin,
                    onEdit: () =>
                        context.go('/inventory/edit-material', extra: mp),
                    onUpdateStock: () => _showStockDialog(
                      context: context,
                      title: 'Actualizar Stock: ${mp.description}',
                      isProduct: false,
                      isAdmin: isAdmin,
                      onConfirm: (delta, _) {
                        if (mp.id != null) {
                          ref
                              .read(rawMaterialProvider.notifier)
                              .updateStock(mp.id!, delta);
                        }
                      },
                    ),
                  ),
                  cells: [
                    AppTableCell.text(mp.sku, flex: 2),
                    AppTableCell.text(mp.description, flex: 3),
                    AppTableCell.text(mp.formattedStock, flex: 1),
                    AppTableCell.text(mp.formattedMinStock, flex: 2),
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

  Widget _buildProductsTab(BuildContext context, WidgetRef ref, bool isAdmin) {
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
                (product) => _buildExpandableTableRow(
                  context,
                  ref,
                  product: product,
                  isAdmin: isAdmin,
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildScrapsTab(BuildContext context, WidgetRef ref, bool isAdmin) {
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
                  trailingWidth: 40,
                  trailing: _buildActionMenu(
                    context,
                    isAdmin: isAdmin,
                    onEdit: () =>
                        context.go('/inventory/edit-scrap', extra: scrap),
                    onUpdateStock: () => _showStockDialog(
                      context: context,
                      title:
                          'Actualizar Retazo: ${scrap.rawMaterial.description}',
                      isProduct: false,
                      isAdmin: isAdmin,
                      onConfirm: (delta, _) {
                        if (scrap.id != null) {
                          ref
                              .read(scrapProvider.notifier)
                              .updateStock(scrap.id!, delta.round());
                        }
                      },
                    ),
                  ),
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
    BuildContext context,
    WidgetRef ref, {
    required ProductGroupUi product,
    required bool isAdmin,
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
          .map(
            (variant) => AppTableRow(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 60,
                right: 24,
              ),
              background: AppColors.surface,
              trailingWidth: 40,
              trailing: _buildActionMenu(
                context,
                isAdmin: isAdmin,
                onEdit: () {
                  context.go('/inventory/edit-product', extra: product);
                },
                onUpdateStock: () => _showStockDialog(
                  context: context,
                  title:
                      'Stock: ${base.description} (${variant.color ?? variant.size ?? variant.sku})',
                  isProduct: true,
                  isAdmin: isAdmin,
                  onConfirm: (delta, deductMp) async {
                    if (variant.id != null) {
                      await ref
                          .read(inventoryProductsProvider.notifier)
                          .updateStock(variant.id!, delta, deductMp);
                      // Si se descontó materia prima, recargamos esa tabla en segundo plano
                      if (delta > 0 && deductMp) {
                        ref
                            .read(rawMaterialProvider.notifier)
                            .fetchRawMaterials();
                      }
                    }
                  },
                ),
              ),
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

  Widget _buildActionMenu(
    BuildContext context, {
    required bool isAdmin,
    required VoidCallback onUpdateStock,
    required VoidCallback onEdit,
  }) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {
        if (value == 'update') onUpdateStock();
        if (value == 'edit') onEdit();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'update', child: Text('Ajustar Stock')),
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        if (isAdmin)
          const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }

  void _showStockDialog({
    required BuildContext context,
    required String title,
    required bool isProduct,
    required bool isAdmin,
    required void Function(double delta, bool deductMp) onConfirm,
  }) {
    double delta = 0;
    bool deductMp = true;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: Text(title, style: context.textTheme.titleMedium),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ingrese la cantidad a sumar o restar.",
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Cantidad (Ej: 5 o -2)",
                      hintText: "0",
                    ),
                    onChanged: (val) {
                      setState(() {
                        delta = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                      });
                    },
                  ),
                  if (isProduct && delta > 0 && isAdmin) ...[
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: deductMp,
                      onChanged: (val) =>
                          setState(() => deductMp = val ?? true),
                      title: Text(
                        "Descontar Materia Prima",
                        style: context.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        "Según la receta asociada a este producto",
                        style: context.textTheme.bodySmall,
                      ),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: delta == 0
                      ? null
                      : () {
                          onConfirm(delta, deductMp);
                          Navigator.pop(context);
                        },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
