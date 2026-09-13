import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_sort_option.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/responsive_filter_bar.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_sort_option_provider.dart';

class WorkFilters extends ConsumerWidget {
  final WorkState? selectedState;
  final WorkSortOption currentSort;

  const WorkFilters({
    super.key,
    required this.selectedState,
    required this.currentSort,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideCompleted = ref.watch(hideCompletedProvider);

    return ResponsiveFilterBar(
      filters: [
        _buildFilter(ref),
        _buildSorted(ref),
        _buildHideCompletedToggle(context, ref, hideCompleted),
      ],
    );
  }

  Widget _buildFilter(WidgetRef ref) {
    return LabeledDropdown<WorkState?>(
      label: 'Filtrar por Estado',
      value: selectedState,
      items: [
        const DropdownMenuItem<WorkState?>(
          value: null,
          child: Text('Todos los estados'),
        ),
        ...WorkState.values.map(
          (state) => DropdownMenuItem<WorkState?>(
            value: state,
            child: Text(state.dbValue),
          ),
        ),
      ],
      onChanged: (WorkState? state) {
        ref.read(workStateFilterProvider.notifier).state = state;
      },
    );
  }

  Widget _buildSorted(WidgetRef ref) {
    return LabeledDropdown<WorkSortOption>(
      label: 'Ordenar por',
      value: currentSort,
      items: WorkSortOption.values
          .map(
            (sort) => DropdownMenuItem<WorkSortOption>(
              value: sort,
              child: Text(sort.label),
            ),
          )
          .toList(),
      onChanged: (WorkSortOption? sort) {
        if (sort != null) {
          ref.read(workSortOptionProvider.notifier).state = sort;
        }
      },
    );
  }

  Widget _buildHideCompletedToggle(
    BuildContext context,
    WidgetRef ref,
    bool hideCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),

      child: SwitchListTile(
        value: hideCompleted,
        onChanged: (value) {
          ref.read(hideCompletedProvider.notifier).state = value;
        },

        tileColor: AppColors.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.outline),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),

        title: Text(
          "Ocultar Finalizados",
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      /* FilterChip(
        label: const Text('Ocultar finalizados'),
        selected: hideCompleted,
        /* labelStyle: TextStyle(
          color: hideCompleted ? Colors.white : Colors.grey[400],
          fontWeight: hideCompleted ? FontWeight.bold : FontWeight.normal,
        ), */
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: hideCompleted ? Colors.transparent : Colors.grey[800]!,
          ),
        ),
        onSelected: (bool value) {
          ref.read(hideCompletedProvider.notifier).state = value;
        },
      ), */
    );
  }
}
