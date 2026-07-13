import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';

class ItemTile extends ConsumerWidget {
  final WorkItemEntity item;

  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String baseName =
        item.variantProduct?.baseProduct.description ??
        item.description ??
        'Sin descripción';

    String? subtitleText;
    if (item.variantProduct != null) {
      final attributes =
          [
                item.variantProduct!.baseProduct.fullCategory,
                item.variantProduct!.color,
                item.variantProduct!.size,
              ]
              .where(
                (attr) => attr != null && attr.toString().trim().isNotEmpty,
              )
              .toList();

      if (attributes.isNotEmpty) {
        subtitleText = attributes.join(' | ');
      }
    }

    subtitleText ??= 'Subtotal: \$${item.subtotal.toStringAsFixed(2)}';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: CheckboxListTile(
        value: item.isDone,
        onChanged: (bool? newValue) {
          if (newValue != null && item.id != null) {
            ref.read(workProvider.notifier).toggleItemDone(item.id!, newValue);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text('${item.quantity}x $baseName'),
        subtitle: Text(subtitleText),
      ),
    );
  }
}
