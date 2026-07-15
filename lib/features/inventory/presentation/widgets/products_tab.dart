import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/expandable_table_row.dart';

class ProductsTab extends ConsumerWidget {
  final bool isAdmin;

  const ProductsTab({super.key, required this.isAdmin});

  static const _productColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final productsState = ref.watch(inventoryProductsProvider);

    return productsState.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No hay productos registrada."));
        }

        final filteredProducts = products.where((product) {
          final baseDescriptionMatch = product.baseProduct.description
              .toLowerCase()
              .contains(searchQuery);
          final categoryMatch = product.baseProduct.category
              .toLowerCase()
              .contains(searchQuery);
          final subcategoryMatch = product.baseProduct.subcategory
              .toLowerCase()
              .contains(searchQuery);
          final baseSkuMatch = product.baseProduct.baseSku
              .toLowerCase()
              .contains(searchQuery);

          final variantSkuMatch = product.variants.any(
            (variant) => variant.sku.toLowerCase().contains(searchQuery),
          );
          final colorMatch = product.variants.any(
            (variant) =>
                variant.color?.toLowerCase().contains(searchQuery) ?? false,
          );
          final sizeMatch = product.variants.any(
            (variant) =>
                variant.size?.toLowerCase().contains(searchQuery) ?? false,
          );

          return baseDescriptionMatch ||
              categoryMatch ||
              subcategoryMatch ||
              baseSkuMatch ||
              variantSkuMatch ||
              colorMatch ||
              sizeMatch;
        }).toList();

        if (filteredProducts.isEmpty) {
          return const Center(
            child: Text("No se encontraron materias primas."),
          );
        }

        return AppTableShell(
          header: const AppTableHeader(
            columns: _productColumns,
            padding: EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 60),
          ),
          rows: filteredProducts
              .map(
                (product) =>
                    ExpandableTableRow(product: product, isAdmin: isAdmin),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }
}
