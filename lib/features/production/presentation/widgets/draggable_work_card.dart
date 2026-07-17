import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/deadline_extensions.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:go_router/go_router.dart';

class DraggableWorkCard extends StatelessWidget {
  final WorkEntity work;

  const DraggableWorkCard({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    final cardUI = Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: AppColors.outline),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'TRB-${work.id}',
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              work.client.fullName,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.onBackground,
              ),
            ),

            const SizedBox(height: 4),

            if (work.deadline != null)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: AppColors.onBackground,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    work.deadline!.mmmDd,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: work.deadline!.deadlineColor,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            if (work.items.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: work.items
                    .map((item) => _buildItemRow(context, item))
                    .toList(),
              ),

            Divider(color: AppColors.outline),

            OutlinedButton(
              onPressed: () {
                context.go('/work/detail', extra: work);
              },
              child: Text("Ver Detalles"),
            ),
          ],
        ),
      ),
    );

    return Draggable<WorkEntity>(
      data: work,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(width: 260, child: cardUI),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: cardUI),
      child: InkWell(onTap: () {}, child: cardUI),
    );
  }

  Widget _buildItemRow(BuildContext context, WorkItemEntity item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            item.isDone
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            size: 14,
            color: item.isDone ? Colors.green : AppColors.onBackground,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              '${item.quantity}x ${item.variantProduct?.baseProduct.description ?? item.description ?? 'Sin desc.'}',
              style: context.textTheme.bodySmall?.copyWith(
                color: item.isDone
                    ? AppColors.onBackground.withValues(alpha: 0.8)
                    : AppColors.onBackground,
                decoration: item.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: AppColors.onBackground,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
