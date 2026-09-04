import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';

class PremiumCard extends ConsumerWidget {
  final bool isExpanded;

  const PremiumCard({super.key, this.isExpanded = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionProvider);

    return subState.when(
      data: (isPremium) {
        if (!isExpanded) {
          return Center(
            child: Tooltip(
              message: isPremium ? 'Usuario Premium' : 'Hazte Premium',

              child: IconButton(
                onPressed: isPremium
                    ? null
                    : () =>
                          ref.read(subscriptionProvider.notifier).openPaywall(),
                icon: Icon(
                  isPremium ? Icons.verified : Icons.workspace_premium,
                  color: isPremium ? Colors.amber[700] : AppColors.primary,
                ),
              ),
            ),
          );
        }

        if (isPremium) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            ),

            child: Row(
              children: [
                Icon(Icons.verified, size: 20, color: Colors.amber[800]),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Usuario Premium',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: Colors.amber[900],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: SizedBox(
            width: double.infinity,

            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.workspace_premium, size: 18),
              label: const Text(
                'Hazte Premium',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                ref.read(subscriptionProvider.notifier).openPaywall();
              },
            ),
          ),
        );
      },
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
