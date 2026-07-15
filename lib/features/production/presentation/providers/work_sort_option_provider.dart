import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/enums/work_sort_option.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';

final workStateFilterProvider = StateProvider<WorkState?>((ref) => null);

final workSortOptionProvider = StateProvider<WorkSortOption>(
  (ref) => WorkSortOption.creationDesc,
);
