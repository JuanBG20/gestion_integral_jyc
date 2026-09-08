import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/utils/product_action_handler.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/category_budget.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/product_variant_card.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductGroupUi product;
  final bool isAdmin;

  const ProductCard({super.key, required this.product, required this.isAdmin});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final base = product.baseProduct;
    final isAdmin = widget.isAdmin;

    return AppCardShell(
      onTapCard: () =>
          context.go('/inventory/edit-product', extra: widget.product),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CategoryBudget(text: base.fullCategory),

                  const SizedBox(height: 8),

                  Text(
                    'SKU: ${base.baseSku}',
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ),

            AppActionMenu(
              items: [
                const AppActionMenuItem(value: 'edit', label: 'Editar'),
                if (widget.isAdmin)
                  const AppActionMenuItem(
                    value: 'delete',
                    label: 'Eliminar',
                    isDestructive: true,
                  ),
              ],
              onSelected: (value) =>
                  handleBaseProductSharedAction(context, ref, product, value),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(base.description, style: context.textTheme.titleMedium),

        const SizedBox(height: 4),

        Divider(color: AppColors.outline),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text("Stock Total", style: context.textTheme.bodySmall),
                Text(product.totalStock.toString()),
              ],
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(isExpanded ? "Ocultar Variantes" : "Ver Variantes"),
            ),
          ],
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,

          child: isExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 8),

                    ...product.variants.map(
                      (variant) => ProductVariantCard(
                        variant: variant,
                        isAdmin: isAdmin,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
