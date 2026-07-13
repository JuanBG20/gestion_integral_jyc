import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/finalizado_drop_zone.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/kanban_column.dart';

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
                  KanbanColumn(
                    title: WorkState.recibido.dbValue,
                    columnState: WorkState.recibido,
                    allWorks: works,
                  ),

                  KanbanColumn(
                    title: WorkState.disenado.dbValue,
                    columnState: WorkState.disenado,
                    allWorks: works,
                  ),

                  KanbanColumn(
                    title: WorkState.hecho.dbValue,
                    columnState: WorkState.hecho,
                    allWorks: works,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            FinalizadoDropZone(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }
}
