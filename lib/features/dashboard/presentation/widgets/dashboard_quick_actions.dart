import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_actions_layout.dart';
import 'package:gestion_integral_jyc/features/production/presentation/utils/work_limit_gate.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/utils/premium_gate.dart';
import 'package:go_router/go_router.dart';

class DashboardQuickActions extends ConsumerWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuickActionsLayout(
      quickActions: [
        QuickActionButton(
          label: 'Nueva Venta',
          icon: Icons.point_of_sale_outlined,
          onPressed: () => context.go('/sales/new'),
        ),

        QuickActionButton(
          label: 'Nueva Órden de Trabajo',
          icon: Icons.add_box_outlined,
          onPressed: () => WorkLimitGate.guardNewWork(
            context,
            ref,
            () => context.go('/work/new'),
          ),
        ),

        QuickActionButton(
          label: 'Registrar Producto',
          icon: Icons.draw_outlined,
          onPressed: () => context.go('/inventory/new-product'),
        ),

        QuickActionButton(
          label: 'Registar Retazo',
          icon: Icons.content_cut_outlined,
          onPressed: () => PremiumGate.guard(
            context,
            ref,
            () => context.go('/inventory/new-scrap'),
          ),
        ),
      ],
    );
  }
}
