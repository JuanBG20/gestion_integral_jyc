import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/client_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_card_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/utils/client_action_handler.dart';
import 'package:go_router/go_router.dart';

class ClientCard extends ConsumerWidget {
  final ClientEntity client;
  final bool isAdmin;

  const ClientCard({super.key, required this.client, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCardShell(
      onTapCard: () => context.go('/clients/edit', extra: client),
      cardContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Text(
                client.fullName,
                style: context.textTheme.titleMedium,
              ),
            ),

            AppActionMenu(
              items: [
                const AppActionMenuItem(value: 'edit', label: 'Editar'),
                if (isAdmin)
                  const AppActionMenuItem(
                    value: 'delete',
                    label: 'Eliminar',
                    isDestructive: true,
                  ),
              ],
              onSelected: (value) =>
                  handleClientSharedAction(context, ref, client, value),
            ),
          ],
        ),

        const SizedBox(height: 8),

        _buildInfoText(
          context,
          icon: Icons.badge_outlined,
          text: client.formattedDocument,
        ),

        const SizedBox(height: 8),

        _buildInfoText(
          context,
          icon: Icons.phone_outlined,
          text: client.displayPhone,
        ),

        const SizedBox(height: 8),

        _buildInfoText(
          context,
          icon: Icons.email_outlined,
          text: client.displayEmail,
        ),

        const SizedBox(height: 8),

        _buildInfoText(
          context,
          icon: Icons.place_outlined,
          text: client.formattedAddress,
        ),

        if (client.additionalNotes != null && client.additionalNotes != '') ...[
          const SizedBox(height: 4),

          Divider(color: AppColors.outline),

          const SizedBox(height: 4),

          _buildInfoText(
            context,
            icon: Icons.sticky_note_2_outlined,
            text: client.additionalNotes!,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoText(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16),

        const SizedBox(width: 8),

        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
