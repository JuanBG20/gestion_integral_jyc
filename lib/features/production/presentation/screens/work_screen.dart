import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/production/presentation/utils/work_limit_gate.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/kanban_board.dart';
import 'package:go_router/go_router.dart';

class WorkScreen extends ConsumerWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToNewWork() =>
        WorkLimitGate.guardNewWork(context, ref, () => context.go('/work/new'));

    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: context.isMobileLayout
          ? FloatingActionButton(
              onPressed: goToNewWork,
              child: const Icon(Icons.add),
            )
          : null,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Órdenes de Trabajo",
              subtitle: "Gestión de trabajos en proceso.",
              buttonLabel: "Nuevo Trabajo",
              onPressed: goToNewWork,

              hasSecondaryButton: true,
              secondaryButtonLabel: "Ver Trabajos",
              secondaryButtonIcon: Icons.visibility_outlined,
              onPressedSecundary: () => context.go('/work/all'),
              hasButtons: true,
            ),

            const SizedBox(height: 24),

            const Expanded(child: KanbanBoard()),
          ],
        ),
      ),
    );
  }
}
