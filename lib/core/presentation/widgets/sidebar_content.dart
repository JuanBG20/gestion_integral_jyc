import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/sidebar_item.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/widgets/premium_card.dart';
import 'package:go_router/go_router.dart';

class SidebarContent extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const SidebarContent({
    super.key,
    required this.navigationShell,
    required this.isExpanded,
    this.onToggleExpand,
  });

  void _goToBranch(WidgetRef ref, int index) {
    // Limpiar texto de búsqueda
    ref.read(searchQueryProvider.notifier).state = '';

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          height: 80,

          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      if (context.isMobileLayout) const SizedBox(height: 20),

                      Text(
                        "J&C Impresiones 3D",
                        style: context.textTheme.titleMedium,
                      ),

                      Text(
                        "Software de Gestión Empresarial",
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.precision_manufacturing,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
        ),

        SidebarItem(
          icon: Icons.dashboard_outlined,
          title: "Dashboard",
          onTap: () => _goToBranch(ref, 0),
          isActive: navigationShell.currentIndex == 0,
          isExpanded: isExpanded,
        ),

        SidebarItem(
          icon: Icons.inventory_2_outlined,
          title: "Inventario",
          onTap: () => _goToBranch(ref, 1),
          isActive: navigationShell.currentIndex == 1,
          isExpanded: isExpanded,
        ),

        SidebarItem(
          icon: Icons.precision_manufacturing_outlined,
          title: "Órdenes de Trabajo",
          onTap: () => _goToBranch(ref, 2),
          isActive: navigationShell.currentIndex == 2,
          isExpanded: isExpanded,
        ),

        SidebarItem(
          icon: Icons.payments_outlined,
          title: "Ventas y Facturación",
          onTap: () => _goToBranch(ref, 3),
          isActive: navigationShell.currentIndex == 3,
          isExpanded: isExpanded,
        ),

        SidebarItem(
          icon: Icons.people_alt_outlined,
          title: "Clientes",
          onTap: () => _goToBranch(ref, 4),
          isActive: navigationShell.currentIndex == 4,
          isExpanded: isExpanded,
        ),

        if (isMobile)
          SidebarItem(
            icon: Icons.qr_code_scanner,
            title: "Escáner",
            onTap: () => context.push('/scanner'),
            isActive: false,
            isExpanded: isExpanded,
          ),

        /* _buildSidebarItem(
                    icon: Icons.settings_outlined,
                    title: "Configuración",
                    onTap: () {},
                    isExpanded: isExpanded,
                  ), */
        Spacer(),

        PremiumCard(isExpanded: isExpanded),

        const SizedBox(height: 4),

        SidebarItem(
          icon: Icons.logout_outlined,
          title: "Cerrar Sesión",
          onTap: () async {
            await ref.read(authProvider.notifier).signOut();
            if (context.mounted) context.go('/login');
          },
          isExpanded: isExpanded,
        ),

        if (!isMobile && onToggleExpand != null)
          SidebarItem(
            icon: isExpanded
                ? Icons.keyboard_double_arrow_left
                : Icons.keyboard_double_arrow_right,
            title: "Colapsar Menú",
            onTap: onToggleExpand!,
            isExpanded: isExpanded,
          ),

        if (context.isMobileLayout) const SizedBox(height: 20),
      ],
    );
  }
}
