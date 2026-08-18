import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:go_router/go_router.dart';

class ProductionSummaryTable extends ConsumerWidget {
  const ProductionSummaryTable({super.key});

  Color _getStateColor(WorkState state) {
    switch (state) {
      case WorkState.recibido:
        return Colors.blue;
      case WorkState.disenado:
        return Colors.orange;
      case WorkState.hecho:
        return Colors.purple;
      case WorkState.notificado:
        return Colors.amber;
      case WorkState.finalizado:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Resumen de Producción",
                style: context.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () => context.go('/work'),
                child: Text("Ver Todo"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          worksState.when(
            data: (works) {
              final allWorks = works;

              if (allWorks.isEmpty) {
                return const Center(child: Text("No hay trabajos en proceso."));
              }

              final stateCounts = <WorkState, int>{};
              for (var state in WorkState.values) {
                stateCounts[state] = 0;
              }

              for (var work in allWorks) {
                stateCounts[work.actualState] =
                    stateCounts[work.actualState]! + 1;
              }

              final areAllFinished = allWorks.every(
                (work) => work.actualState == WorkState.finalizado,
              );

              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      height: 25,
                      child: Row(
                        children: areAllFinished
                            ? [
                                Expanded(
                                  child: Tooltip(
                                    message:
                                        '${WorkState.finalizado.dbValue}: ${allWorks.length}',
                                    child: Container(
                                      color: _getStateColor(
                                        WorkState.finalizado,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : stateCounts.entries
                                  .where(
                                    (entry) =>
                                        entry.key != WorkState.finalizado &&
                                        entry.value > 0,
                                  )
                                  .map((entry) {
                                    final state = entry.key;
                                    final count = entry.value;

                                    return Expanded(
                                      flex: count,
                                      child: Tooltip(
                                        message: '${state.dbValue}: $count',
                                        child: Container(
                                          color: _getStateColor(state),
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: stateCounts.entries.map((entry) {
                      final state = entry.key;
                      final count = entry.value;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStateColor(state),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${state.dbValue} ($count)",
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: count > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: count == 0 ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(child: Text("Error: $e")),
          ),
        ],
      ),
    );
  }
}
