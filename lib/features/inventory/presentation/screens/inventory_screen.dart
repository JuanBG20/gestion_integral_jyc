import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/products_tab_wrapper.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/raw_materials/raw_materials_tab_wrapper.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/scraps/scraps_tab_wrapper.dart';
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
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      if (isAdmin) ...[
                        FloatingActionButton.small(
                          heroTag: "btn_small",
                          onPressed: () =>
                              context.go('inventory/price-preview'),
                          child: const Icon(Icons.price_check),
                        ),

                        const SizedBox(height: 8),
                      ],

                      FloatingActionButton(
                        heroTag: "btn_main",
                        onPressed: () => _newItemNavigation(tabContext),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  )
                : null,

            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: 8,
                      ),

                      child: ScreenHeader(
                        title: "Inventario",
                        subtitle:
                            "Gestión de productos terminados, materia prima y retazos.",
                        buttonLabel: "Nuevo Item",
                        onPressed: () => _newItemNavigation(tabContext),
                        hasSecondaryButton: isAdmin,
                        secondaryButtonLabel: "Actualizar Precios",
                        secondaryButtonIcon: Icons.price_check,
                        onPressedSecundary: () =>
                            context.go('inventory/price-preview'),
                      ),
                    ),
                  ),

                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.surface,
                    forceElevated: innerBoxIsScrolled,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 0,

                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),

                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerColor: AppColors.outline,
                          tabs: const [
                            Tab(text: "Materia Prima"),
                            Tab(text: "Productos"),
                            Tab(text: "Retazos"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  RawMaterialsTabWrapper(isAdmin: isAdmin),
                  ProductsTabWrapper(isAdmin: isAdmin),
                  ScrapsTabWrapper(isAdmin: isAdmin),
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
