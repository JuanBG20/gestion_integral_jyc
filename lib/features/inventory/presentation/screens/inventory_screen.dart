import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products_tab.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/raw_materials_tab.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/scraps_tab.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return DefaultTabController(
      length: 3,

      child: Builder(
        builder: (BuildContext tabContext) {
          return Scaffold(
            backgroundColor: AppColors.surface,

            floatingActionButton: context.isMobileLayout
                ? FloatingActionButton(
                    onPressed: () => _newItemNavigation(tabContext),
                    child: const Icon(Icons.add),
                  )
                : null,

            body: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ScreenHeader(
                    title: "Inventario",
                    subtitle:
                        "Gestión de productos terminados, materia prima y retazos.",
                    buttonLabel: "Nuevo Item",
                    onPressed: () => _newItemNavigation(tabContext),
                  ),

                  const SizedBox(height: 8),

                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: AppColors.outline,

                    tabs: const [
                      Tab(text: "Materia Prima"),
                      Tab(text: "Productos"),
                      Tab(text: "Retazos"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: TabBarView(
                      children: [
                        RawMaterialsTab(isAdmin: isAdmin),
                        ProductsTab(isAdmin: isAdmin),
                        ScrapsTab(isAdmin: isAdmin),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _newItemNavigation(BuildContext tabContext) {
    final currentIndex = DefaultTabController.of(tabContext).index;

    switch (currentIndex) {
      case 0:
        tabContext.go('/inventory/new-material');
        break;
      case 1:
        tabContext.go('/inventory/new-product');
        break;
      case 2:
        tabContext.go('/inventory/new-scrap');
        break;
    }
  }
}
