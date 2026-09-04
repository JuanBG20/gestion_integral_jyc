import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/search_app_bar.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/sidebar_content.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class Layout extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const Layout({super.key, required this.navigationShell});

  @override
  ConsumerState<Layout> createState() => _LayoutState();
}

class _LayoutState extends ConsumerState<Layout> {
  bool _isSidebarExpanded = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool haveSearchBar =
        currentPath == '/inventory' || currentPath == '/clients';

    return Scaffold(
      drawer: context.isMobileLayout
          ? Drawer(
              child: SafeArea(
                child: SidebarContent(
                  navigationShell: widget.navigationShell,
                  isExpanded: true,
                ),
              ),
            )
          : null,

      appBar: context.isMobileLayout
          ? AppBar(title: const Text("J&C Impresiones 3D"))
          : null,

      body: SafeArea(
        child: Row(
          children: [
            if (!context.isMobileLayout)
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

                child: SidebarContent(
                  navigationShell: widget.navigationShell,
                  isExpanded: _isSidebarExpanded,
                  onToggleExpand: _toggleSidebar,
                ),
              ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  if (haveSearchBar) const SearchAppBar(),

                  Expanded(child: widget.navigationShell),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
