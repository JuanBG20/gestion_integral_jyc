import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_sort_option.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_sort_option_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/all_works_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/work_card.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/work_filters.dart';
import 'package:go_router/go_router.dart';

class AllWorksScreenWrapper extends ConsumerWidget {
  const AllWorksScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksState = ref.watch(workProvider);

    final selectedState = ref.watch(workStateFilterProvider);
    final currentSort = ref.watch(workSortOptionProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: context.isMobileLayout
          ? FloatingActionButton(
              onPressed: () => context.go('/work/new'),
              child: const Icon(Icons.add),
            )
          : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Órdenes de Trabajo",
              subtitle: "Gestión de trabajos en proceso.",
              buttonLabel: "Nuevo Trabajo",
              onPressed: () => context.go('/work/new'),
            ),

            const SizedBox(height: 24),

            WorkFilters(selectedState: selectedState, currentSort: currentSort),

            const SizedBox(height: 24),

            worksState.when(
              data: (works) {
                if (works.isEmpty) {
                  return const Center(
                    child: Text("No hay trabajos registrados."),
                  );
                }

                var processedWorks = works.where((w) {
                  // Filtro de Estado
                  if (selectedState != null && w.actualState != selectedState) {
                    return false;
                  }

                  return true;
                }).toList();

                // Ordenamiento de fechas
                processedWorks.sort((a, b) {
                  switch (currentSort) {
                    case WorkSortOption.creationDesc:
                      return b.creationDate.compareTo(a.creationDate);
                    case WorkSortOption.creationAsc:
                      return a.creationDate.compareTo(b.creationDate);
                    case WorkSortOption.deadlineAsc:
                      if (a.deadline == null && b.deadline == null) return 0;
                      if (a.deadline == null) return 1;
                      if (b.deadline == null) return -1;
                      return a.deadline!.compareTo(b.deadline!);
                    case WorkSortOption.deadlineDesc:
                      if (a.deadline == null && b.deadline == null) return 0;
                      if (a.deadline == null) return 1;
                      if (b.deadline == null) return -1;
                      return b.deadline!.compareTo(a.deadline!);
                  }
                });

                if (processedWorks.isEmpty) {
                  return const Center(
                    child: Text(
                      "No se encontraron trabajos con estos filtros.",
                    ),
                  );
                }

                return context.isMobileLayout
                    ? AppMobileList<WorkEntity>(
                        items: processedWorks,
                        itemBuilder: (context, work) => WorkCard(work: work),
                      )
                    : AllWorksScreen(works: processedWorks);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text("Error: $e")),
            ),
          ],
        ),
      ),
    );
  }
}
