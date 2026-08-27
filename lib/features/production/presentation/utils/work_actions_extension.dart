import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:go_router/go_router.dart';

extension WorkActionsExtension on BuildContext {
  void handleWorkAction(WorkEntity work, String action) {
    switch (action) {
      case 'details':
        go('/work/detail', extra: work);
      case 'edit':
        go('/work/edit', extra: work);
    }
  }
}
