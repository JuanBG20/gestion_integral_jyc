import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class Layout extends StatefulWidget {
  final Widget child;

  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool _isSidebarExpanded = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: _isSidebarExpanded ? 256 : 80,

            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: AppColors.outline, width: 1),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(
                  height: 80,

                  child: _isSidebarExpanded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
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

                _buildSidebarItem(
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  onTap: () {},
                  isActive: true,
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: Icons.inventory_2_outlined,
                  title: "Inventario",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: Icons.precision_manufacturing_outlined,
                  title: "Órdenes de Trabajo",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: Icons.payments_outlined,
                  title: "Ventas y Facturación",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: Icons.people_alt_outlined,
                  title: "Clientes",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: Icons.settings_outlined,
                  title: "Configuración",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                Spacer(),

                _buildSidebarItem(
                  icon: Icons.logout_outlined,
                  title: "Cerrar Sesión",
                  onTap: () {},
                  isExpanded: _isSidebarExpanded,
                ),

                _buildSidebarItem(
                  icon: _isSidebarExpanded
                      ? Icons.keyboard_double_arrow_left
                      : Icons.keyboard_double_arrow_right,
                  title: "Colapsar Menú",
                  onTap: _toggleSidebar,
                  isExpanded: _isSidebarExpanded,
                ),
              ],
            ),
          ),

          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    required VoidCallback onTap,
    required isExpanded,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 16 : 0,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 4,
              ),
            ),
          ),

          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,

            children: [
              Tooltip(
                message: title,
                waitDuration: const Duration(milliseconds: 500),

                child: Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.onBackground,
                ),
              ),

              if (isExpanded)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),

                    child: Text(
                      title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.onBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
