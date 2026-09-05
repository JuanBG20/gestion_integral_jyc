import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:go_router/go_router.dart';

void handleClientSharedAction(
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
  }
}
