import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/draggable_work_card.dart';

class KanbanColumn extends ConsumerWidget {
  final String title;
  final WorkState columnState;
  final List<WorkEntity> allWorks;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.columnState,
    required this.allWorks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      return DraggableWorkCard(work: columnWorks[index]);
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
}
