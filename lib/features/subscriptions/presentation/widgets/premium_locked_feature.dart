import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/utils/premium_gate.dart';

class PremiumLockedFeature extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String description;

  const PremiumLockedFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 48, color: AppColors.primary),

            const SizedBox(height: 16),

            Text(title, style: context.textTheme.titleMedium),

            const SizedBox(height: 8),

            Text(
              description,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => PremiumGate.guard(context, ref, () {}),
              label: const Text("Ver planes premium"),
              icon: const Icon(Icons.workspace_premium_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
