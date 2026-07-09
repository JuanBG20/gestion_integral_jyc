import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Órdenes de Trabajo",
                      style: context.textTheme.titleLarge,
                    ),
                    Text(
                      "Gestión de trabajos en proceso.",
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: () => context.go('/work/new'),
                  label: Text("Nuevo Trabajo"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Expanded(child: KanbanBoard()),
          ],
        ),
      ),
    );
  }
}
