import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';

class WorkItemsListSection extends StatefulWidget {
  const WorkItemsListSection({super.key});

  @override
  State<WorkItemsListSection> createState() => _WorkItemsListSectionState();
}

class _WorkItemsListSectionState extends State<WorkItemsListSection> {
  List<WorkItemEntity> _items = [];

  @override
  void initState() {
    super.initState();
    _loadMocks();
  }

  void _loadMocks() {
    _items = [
      WorkItemEntity(
        id: 1,
        isDone: true,
        quantity: 5,
        unitPrice: 49.0, // 5 * 49 = 245.00
        variantProduct: VariantProductEntity(
          sku: 'VAR-001',
          stock: 10,
          costPrice: 20.0,
          salePrice: 49.0,
          manufacturingRecipe: [],
          baseProduct: BaseProductEntity(
            baseSku: 'BAS-001',
            category: 'Piezas',
            subcategory: 'Sensores',
            description: 'Carcasa Sensor de Temperatu',
          ),
        ),
      ),
      WorkItemEntity(
        id: 2,
        isDone: false,
        quantity: 1,
        unitPrice: 180.0,
        variantProduct: VariantProductEntity(
          sku: 'VAR-002',
          stock: 5,
          costPrice: 50.0,
          salePrice: 180.0,
          manufacturingRecipe: [],
          baseProduct: BaseProductEntity(
            baseSku: 'BAS-002',
            category: 'Piezas',
            subcategory: 'Engranajes',
            description: 'Engranaje Helicoidal M4',
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text("Ítems a Producir", style: context.textTheme.titleMedium),

            TextButton.icon(
              onPressed: () {},
              label: Text("Producto Genérico"),
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),

        Divider(color: AppColors.outline),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildItemCard(_items[index], index);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: _items.length,
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),

          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              // TODO: Dotted border
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Icon(Icons.add, color: AppColors.onBackground),

                const SizedBox(width: 8),

                Text(
                  "Click para agregar otro ítem...",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(WorkItemEntity item, int index) {
    final itemName =
        item.variantProduct?.baseProduct.description ??
        item.description ??
        'Ítem sin nombre';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [
          Checkbox(value: item.isDone, onChanged: (bool? newValue) {}),

          Expanded(child: Text(itemName, style: context.textTheme.bodyMedium)),

          Text("Cant:", style: context.textTheme.bodySmall),

          const SizedBox(width: 4),

          SizedBox(width: 60, child: TextField()),

          const SizedBox(width: 32),

          Text(
            "\$${item.subtotal.toStringAsFixed(2)}",
            style: context.textTheme.bodyMedium,
          ),

          const SizedBox(width: 16),

          IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}
