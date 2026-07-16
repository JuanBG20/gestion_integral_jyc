import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_sort_option.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.isMobileLayout) {
          return Column(
            children: [
              // Filtro por Estado
              SizedBox(width: double.infinity, child: _buildFilter(ref)),

              const SizedBox(height: 16),

              // Ordenamiento
              SizedBox(width: double.infinity, child: _buildSorted(ref)),
            ],
          );
        }

        return Row(
          children: [
            // Filtro por Estado
            Expanded(child: _buildFilter(ref)),

            const SizedBox(width: 16),

            // Ordenamiento
            Expanded(child: _buildSorted(ref)),
          ],
        );
      },
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
}
