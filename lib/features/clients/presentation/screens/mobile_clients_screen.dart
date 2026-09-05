import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/client_card.dart';

class MobileClientsScreen extends ConsumerWidget {
  final List<ClientEntity> clients;
  final bool isAdmin;

  const MobileClientsScreen({
    super.key,
    required this.clients,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {
        return ClientCard(client: clients[index], isAdmin: isAdmin);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: clients.length,
    );
  }
}
