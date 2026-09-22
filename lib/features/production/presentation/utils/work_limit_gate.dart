import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/utils/premium_gate.dart';

class WorkLimitGate {
  static const int freeActiveLimit = 5;

  static void guardNewWork(
    BuildContext context,
    WidgetRef ref,
    VoidCallback action,
  ) {
    final isPremium = ref.read(subscriptionProvider).asData?.value ?? false;
    if (isPremium) {
      action();
      return;
    }

    final activeCount = ref.read(activeWorksCountProvider);
    if (activeCount < freeActiveLimit) {
      action();
      return;
    }

    _showLimitDialog(context, ref);
  }

  static void _showLimitDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Límite de trabajos activos"),
        content: Text(
          "En el plan gratuito podés tener hasta $freeActiveLimit trabajos "
          "activos a la vez. Finalizá alguno o pasate a Premium para "
          "trabajos ilimitados.",
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cerrar"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              PremiumGate.guard(context, ref, () {});
            },
            child: const Text("Ver Premium"),
          ),
        ],
      ),
    );
  }
}
