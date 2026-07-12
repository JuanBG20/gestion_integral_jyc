import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
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
    final clientsState = ref.watch(clientProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Gestión de Clientes",
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        "Directorio y perfiles de facturación.",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                ElevatedButton.icon(
                  onPressed: () => context.go('/clients/new'),
                  label: Text("Nuevo Cliente"),
                  icon: Icon(Icons.add),
                ),
              ],
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
                          .map((c) => _buildClientRow(context, ref, client: c))
                          .toList(),
                    ),

                    _buildPaginationFooter(
                      context,
                      total: clients.length,
                      shown: clients.length,
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
  }) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      trailingWidth: 100,
      trailing: SizedBox(
        width: 40,
        child: _buildActionMenu(context, ref, client),
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
          _formatAddress(client),
          flex: 3,
          style: context.textTheme.bodyMedium,
        ),
        AppTableCell(flex: 2, child: _buildNotesCell(context, client: client)),
      ],
    );
  }

  Widget _buildDocCell(BuildContext context, {required ClientEntity client}) {
    if (client.docType == null || client.docNumber == null) {
      return Text("-", style: context.textTheme.bodyMedium);
    }

    return Text(
      '${client.docType!.dbValue} ${client.docNumber}',
      style: context.textTheme.bodyMedium,
    );
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
              client.email ?? "No especificado",
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

            Text(
              client.phoneNumber ?? "No especificado",
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesCell(BuildContext context, {required ClientEntity client}) {
    if (client.additionalNotes == null || client.additionalNotes!.isEmpty) {
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

  Widget _buildActionMenu(
    BuildContext context,
    WidgetRef ref,
    ClientEntity client,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {
        if (value == 'delete' && client.id != null) {
          ref.read(clientProvider.notifier).removeClient(client.id!);
        }
        if (value == 'edit') {
          context.go('/clients/edit', extra: client);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('Ver Perfil')),
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }

  Widget _buildPaginationFooter(
    BuildContext context, {
    required int total,
    required int shown,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            "Mostrando 1-$shown de $total clientes",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onBackground,
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAddress(ClientEntity client) {
    final address = client.address;
    if (address == null) return "Sin dirección";

    final streetLine = [
      address.street,
      address.number,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    final floorAndApt = [
      address.floor,
      address.apartment,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    final parts = [
      if (streetLine.isNotEmpty) streetLine,
      if (floorAndApt.isNotEmpty) floorAndApt,
      if (address.location != null && address.location!.isNotEmpty)
        address.location!,
      if (address.province != null) address.province!.label,
    ];

    return parts.isEmpty ? "Sin dirección" : parts.join(', ');
  }
}
