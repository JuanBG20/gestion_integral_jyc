import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/product_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/product_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/products_tab.dart';

class ProductsTabWrapper extends ConsumerWidget {
  final bool isAdmin;

  const ProductsTabWrapper({super.key, required this.isAdmin});

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

        return context.isMobileLayout
            ? AppMobileList<ProductGroupUi>(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                items: filteredProducts,
                itemBuilder: (context, product) =>
                    ProductCard(product: product, isAdmin: isAdmin),
              )
            : Padding(
                padding: const EdgeInsets.all(24),

                child: ProductsTab(
                  products: filteredProducts,
                  isAdmin: isAdmin,
                ),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }
}
