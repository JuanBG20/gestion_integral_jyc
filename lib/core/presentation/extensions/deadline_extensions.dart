import 'dart:ui';

import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

enum DeadlineUrgency { normal, yellow, orange, red }

extension DeadlineExtensions on DateTime {
  int get daysUntil {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final thisDate = DateTime(year, month, day);
    return thisDate.difference(todayDate).inDays;
  }

  // Rojo: día antes, el día actual, o vencido.
  // Naranja: 2 días antes.
  // Amarillo: entre 3 y 5 días antes.
  DeadlineUrgency get deadlineUrgency {
    final diff = daysUntil;
    if (diff <= 1) return DeadlineUrgency.red;
    if (diff <= 2) return DeadlineUrgency.orange;
    if (diff <= 5) return DeadlineUrgency.yellow;
    return DeadlineUrgency.normal;
  }

  Color? get deadlineColor {
    switch (deadlineUrgency) {
      case DeadlineUrgency.red:
        return AppColors.deadlineRed;
      case DeadlineUrgency.orange:
        return AppColors.deadlineOrange;
      case DeadlineUrgency.yellow:
        return AppColors.deadlineYellow;
      case DeadlineUrgency.normal:
        return null;
    }
  }
}
