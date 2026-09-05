import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/clients_screen.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/mobile_clients_screen.dart';
import 'package:go_router/go_router.dart';

class ClientsScreenWrapper extends ConsumerWidget {
  const ClientsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsState = ref.watch(clientProvider);

    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: context.isMobileLayout
          ? FloatingActionButton(
              onPressed: () => context.go('/clients/new'),
              child: const Icon(Icons.add),
            )
          : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

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

                final filteredClients = clients.where((client) {
                  final nameMatch = client.name.toLowerCase().contains(
                    searchQuery,
                  );
                  final dniMatch =
                      client.docNumber?.contains(searchQuery) ?? false;
                  final emailMatch =
                      client.email?.toLowerCase().contains(searchQuery) ??
                      false;

                  return nameMatch || emailMatch || dniMatch;
                }).toList();

                if (filteredClients.isEmpty) {
                  return const Center(
                    child: Text("No se encontraron clientes."),
                  );
                }

                return context.isMobileLayout
                    ? MobileClientsScreen(
                        clients: filteredClients,
                        isAdmin: isAdmin,
                      )
                    : ClientsScreen(clients: filteredClients, isAdmin: isAdmin);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }
}
