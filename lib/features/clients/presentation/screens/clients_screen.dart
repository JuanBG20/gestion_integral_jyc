import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/client_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/pagination_footer.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:go_router/go_router.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  static const _clientColumns = [
    AppTableColumn(label: "NOMBRE", flex: 3),
    AppTableColumn(label: "DOCUMENTO", flex: 2),
    AppTableColumn(label: "CONTACTO", flex: 3),
    AppTableColumn(label: "DIRECCIÓN", flex: 3),
    AppTableColumn(label: "NOTAS", flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final clientsState = ref.watch(clientProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            ScreenHeader(
              title: "Gestión de Clientes",
              subtitle: "Directorio y perfiles de facturación.",
              buttonLabel: "Nuevo Cliente",
              onPressed: () => context.go('/clients/new'),
            ),

            const SizedBox(height: 32),

            clientsState.when(
              data: (clients) {
                if (clients.isEmpty) {
                  return const Center(
                    child: Text("No hay clientes registrados."),
                  );
                }

                return Column(
                  children: [
                    AppTableShell(
                      shrinkWrap: true,
                      minWidth: 1200,
                      header: const AppTableHeader(
                        columns: _clientColumns,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        trailingWidth: 100,
                      ),
                      rows: clients
                          .map(
                            (c) => _buildClientRow(
                              context,
                              ref,
                              client: c,
                              isAdmin: isAdmin,
                            ),
                          )
                          .toList(),
                    ),

                    PaginationFooter(
                      total: clients.length,
                      shown: clients.length,
                      label: 'clientes',
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientRow(
    BuildContext context,
    WidgetRef ref, {
    required ClientEntity client,
    required bool isAdmin,
  }) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      trailingWidth: 100,
      trailing: SizedBox(
        width: 40,
        child: AppActionMenu(
          items: [
            const AppActionMenuItem(value: 'view', label: 'Ver Perfil'),
            const AppActionMenuItem(value: 'edit', label: 'Editar'),
            if (isAdmin)
              const AppActionMenuItem(
                value: 'delete',
                label: 'Eliminar',
                isDestructive: true,
              ),
          ],
          onSelected: (value) =>
              _handleClientAction(context, ref, client, value),
        ),
      ),
      cells: [
        AppTableCell.text(
          client.fullName,
          flex: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppTableCell(flex: 2, child: _buildDocCell(context, client: client)),
        AppTableCell(
          flex: 3,
          child: _buildContactCell(context, client: client),
        ),
        AppTableCell.text(
          client.formattedAddress,
          flex: 3,
          style: context.textTheme.bodyMedium,
        ),
        AppTableCell(flex: 2, child: _buildNotesCell(context, client: client)),
      ],
    );
  }

  Widget _buildDocCell(BuildContext context, {required ClientEntity client}) {
    return Text(client.formattedDocument, style: context.textTheme.bodyMedium);
  }

  Widget _buildContactCell(
    BuildContext context, {
    required ClientEntity client,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.mail_outline, size: 16, color: AppColors.onBackground),

            const SizedBox(width: 6),

            Text(
              client.displayEmail,
              style: context.textTheme.bodyMedium?.copyWith(
                color: client.email != null
                    ? AppColors.primary
                    : AppColors.onBackground,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.call_outlined, size: 16, color: AppColors.onBackground),

            const SizedBox(width: 6),

            Text(client.displayPhone, style: context.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesCell(BuildContext context, {required ClientEntity client}) {
    if (!client.hasNotes) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(4),
            ),

            child: Text(
              client.additionalNotes!,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall,
            ),
          ),
        ),

        const SizedBox(width: 4),

        Icon(Icons.info_outline, size: 16, color: AppColors.onBackground),
      ],
    );
  }

  void _handleClientAction(
    BuildContext context,
    WidgetRef ref,
    ClientEntity client,
    String action,
  ) {
    switch (action) {
      case 'delete':
        if (client.id != null) {
          ref.read(clientProvider.notifier).removeClient(client.id!);
        }
      case 'edit':
        context.go('/clients/edit', extra: client);
      case 'view':
      // TODO: Ver Perfil de Cliente
    }
  }
}
