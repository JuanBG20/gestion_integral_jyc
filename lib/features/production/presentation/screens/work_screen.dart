import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/kanban_board.dart';
import 'package:go_router/go_router.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Órdenes de Trabajo",
              subtitle: "Gestión de trabajos en proceso.",
              buttonLabel: "Nuevo Trabajo",
              onPressed: () => context.go('/work/new'),

              hasSecondaryButton: true,
              secondaryButtonLabel: "Ver Trabajos",
              secondaryButtonIcon: Icons.visibility_outlined,
              onPressedSecundary: () => context.go('/work/all'),
            ),

            const SizedBox(height: 24),

            const Expanded(child: KanbanBoard()),
          ],
        ),
      ),
    );
  }
}
