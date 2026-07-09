import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  static const _clientColumns = [
    AppTableColumn(label: "NOMBRE", flex: 3),
    AppTableColumn(label: "DOCUMENTO", flex: 2),
    AppTableColumn(label: "CONTACTO", flex: 3),
    AppTableColumn(label: "DIRECCIÓN", flex: 3),
    AppTableColumn(label: "NOTAS", flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final clientes = _mockClients;

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
                  onPressed: () {},
                  label: Text("Nuevo Cliente"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 32),

            AppTableShell(
              shrinkWrap: true,
              minWidth: 1200,
              header: const AppTableHeader(
                columns: _clientColumns,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                trailingWidth: 100,
              ),
              rows: clientes
                  .map((c) => _buildClientRow(context, client: c))
                  .toList(),
            ),

            _buildPaginationFooter(context, total: 45, shown: clientes.length),
          ],
        ),
      ),
    );
  }

  Widget _buildClientRow(BuildContext context, {required ClientEntity client}) {
    return AppTableRow(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      trailingWidth: 100,
      trailing: SizedBox(width: 40, child: _buildActionMenu(context)),
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

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.onBackground),
      onSelected: (value) {},
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

    final floorAndApt = [
      address.floor,
      address.apartment,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    final parts = [
      '${address.street} ${address.number}',
      if (floorAndApt.isNotEmpty) floorAndApt,
      address.location,
      address.province,
    ];

    return parts.join(', ');
  }

  static final List<ClientEntity> _mockClients = [
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Roberto',
      lastName: 'Carlos',
      docType: DocType.cuit,
      docNumber: '30-71234567-8',
      email: 'compras@inghernan.com.ar',
      phoneNumber: '+54 11 4321-8765',
      additionalNotes: 'Cliente Frecuente',
      address: AddressEntity(
        street: 'Av. Industrial',
        number: '450',
        location: 'Parque Ind. Pilar',
        province: 'BA',
      ),
    ),
    ClientEntity(
      name: 'Lucía',
      lastName: 'Martínez',
      docType: DocType.dni,
      docNumber: '35.456.789',
      email: 'lmartinez.design@gmail.com',
      phoneNumber: '+54 9 11 2345-6789',
      additionalNotes: 'Estudiante de arquitectura',
      address: AddressEntity(
        street: 'Calle Falsa',
        number: '123',
        floor: '4to',
        apartment: 'B',
        location: 'CABA',
        province: 'CABA',
      ),
    ),
    ClientEntity(
      name: 'Mecánica',
      lastName: 'Romero',
      docType: DocType.cuit,
      docNumber: '20-22334455-9',
      phoneNumber: '+54 351 456-7890',
      additionalNotes: 'Piezas PETG',
      address: AddressEntity(
        street: 'Ruta 9 Km 12',
        number: '',
        location: 'Córdoba',
        province: 'Córdoba',
      ),
    ),
  ];
}
