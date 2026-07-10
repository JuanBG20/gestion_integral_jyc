import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class KanbanBoard extends ConsumerWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);

    return worksState.when(
      data: (works) {
        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildColumn(
                    context,
                    ref,
                    'RECIBIDO',
                    WorkState.recibido,
                    works,
                  ),
                  _buildColumn(
                    context,
                    ref,
                    'DISEÑADO',
                    WorkState.disenado,
                    works,
                  ),
                  _buildColumn(context, ref, 'HECHO', WorkState.hecho, works),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildFinalizadoDropZone(context, ref),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    WidgetRef ref,
    String title,
    WorkState columnState,
    List<WorkEntity> allWorks,
  ) {
    final columnWorks = allWorks
        .where((w) => w.actualState == columnState)
        .toList();

    return Expanded(
      child: DragTarget<WorkEntity>(
        onWillAcceptWithDetails: (details) =>
            details.data.actualState != columnState,
        onAcceptWithDetails: (details) {
          if (details.data.id != null) {
            ref
                .read(workProvider.notifier)
                .updateWorkStatus(details.data.id!, columnState);
          }
        },
        builder: (context, candidateData, rejectedData) {
          final isHovered = candidateData.isNotEmpty;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isHovered
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isHovered ? AppColors.primary : AppColors.outline,
              ),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(title),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),

                        child: Text('${columnWorks.length}'),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: columnWorks.length,
                    itemBuilder: (context, index) {
                      return _buildDraggableCard(context, columnWorks[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableCard(BuildContext context, WorkEntity work) {
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
                    DateFormat('MMM. d').format(work.deadline!),
                    style: context.textTheme.bodySmall,
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

  // --- DROP ZONE ---
  Widget _buildFinalizadoDropZone(BuildContext context, WidgetRef ref) {
    return DragTarget<WorkEntity>(
      onWillAcceptWithDetails: (details) =>
          details.data.actualState != WorkState.finalizado,
      onAcceptWithDetails: (details) {
        if (details.data.id != null) {
          ref
              .read(workProvider.notifier)
              .updateWorkStatus(details.data.id!, WorkState.finalizado);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trabajo TRB-${details.data.id} marcado como FINALIZADO y enviado a Ventas.',
              ),
            ),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isHovered ? 100 : 80,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isHovered ? Colors.green.shade50 : Colors.grey.shade50,
            border: Border.all(
              color: isHovered ? Colors.green : Colors.grey.shade400,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: isHovered ? Colors.green : Colors.grey.shade600,
                  size: 32,
                ),

                const SizedBox(width: 12),

                Text(
                  isHovered
                      ? '¡Soltar para finalizar!'
                      : 'Arrastrar aquí los trabajos abonados y retirados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isHovered ? Colors.green : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
