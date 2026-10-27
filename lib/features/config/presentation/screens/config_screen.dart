import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/config/presentation/widgets/payment_method_discounts_section.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('¿Eliminar cuenta?'),
        content: const Text(
          'Se eliminarán de forma permanente tu perfil, datos y actividad asociada. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Eliminar',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).deleteAccount();

      if (context.mounted) {
        final authState = ref.read(authProvider);

        if (authState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Configuración",
              subtitle: "Gestioná tus preferencias.",
              hasButtons: false,
            ),

            const SizedBox(height: 24),

            Text(
              "Descuentos por Método de Pago",
              style: context.textTheme.titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              "Se aplican automáticamente al cobrar. Las ventas ya registradas no cambian.",
              style: context.textTheme.bodySmall,
            ),

            Divider(color: AppColors.outline),

            const PaymentMethodDiscountsSection(),

            const SizedBox(height: 24),
            Divider(color: AppColors.outline),

            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                'Eliminar cuenta',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
              subtitle: const Text(
                'Esta acción es irreversible y borrará tus datos',
              ),
              onTap: () => _showDeleteConfirmation(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
