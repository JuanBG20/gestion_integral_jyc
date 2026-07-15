import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/role.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';

class SearchAppBar extends ConsumerStatefulWidget {
  const SearchAppBar({super.key});

  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final activeRole = authState.activeRole;
    final canSwitchRole = user != null && user.roles.length > 1;

    final currentSearch = ref.watch(searchQueryProvider);
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (next != _searchController.text) {
        _searchController.text = next;
      }
    });

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
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: "Buscar...",
                    prefixIcon: Icon(Icons.search, color: AppColors.outline),

                    suffixIcon: currentSearch.isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.outline,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
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
