import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/providers/auth_provider.dart';

class SearchAppBar extends ConsumerWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final activeRole = authState.activeRole;
    final canSwitchRole = user != null && user.roles.length > 1;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 256,

                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: "Buscar...",
                    prefixIcon: Icon(Icons.search, color: AppColors.outline),
                  ),
                ),
              ),

              Spacer(),

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined),
              ),

              const SizedBox(width: 8),

              VerticalDivider(
                indent: 8,
                endIndent: 8,
                color: AppColors.outline,
              ),

              const SizedBox(width: 16),

              PopupMenuButton<Role>(
                enabled: canSwitchRole,
                tooltip: canSwitchRole ? 'Cambiar rol' : '',
                onSelected: (role) =>
                    ref.read(authProvider.notifier).switchRole(role),
                itemBuilder: (context) => (user?.roles ?? [])
                    .map((r) => PopupMenuItem(value: r, child: Text(r.label)))
                    .toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Text(activeRole?.label ?? '-'),

                        Text(
                          user?.fullName ?? '',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (canSwitchRole) ...[
                      const SizedBox(width: 4),

                      Icon(
                        Icons.expand_more,
                        size: 18,
                        color: AppColors.onBackground,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
