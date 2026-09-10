import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/mp_movements.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/quick_sale.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sales_record.dart';
import 'package:go_router/go_router.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoot = ref.watch(isRootProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      floatingActionButton: context.isMobileLayout
          ? FloatingActionButton(
              onPressed: () => context.go('/sales/new'),
              child: const Icon(Icons.add),
            )
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.isDesktopLayout) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  ScreenHeader(
                    title: "Ventas y Facturación",
                    subtitle:
                        "Registra ventas, controla las transacciones y emite facturas.",
                    buttonLabel: "Nueva Venta",
                    onPressed: () => context.go('/sales/new'),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 6, child: _buildLeftColumn(isRoot)),

                      const SizedBox(width: 24),

                      Expanded(flex: 4, child: QuickSale()),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return DefaultTabController(
              length: isRoot ? 3 : 2,

              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsetsGeometry.only(
                              left: 24,
                              right: 24,
                              top: 24,
                              bottom: 8,
                            ),

                            child: ScreenHeader(
                              title: "Ventas y Facturación",
                              subtitle:
                                  "Registra ventas, controla las transacciones y emite facturas.",
                              buttonLabel: "Nueva Venta",
                              onPressed: () => context.go('/sales/new'),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),

                              child: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                dividerColor: AppColors.outline,

                                tabs: [
                                  const Tab(text: "Venta Rápida"),
                                  const Tab(text: "Registro"),
                                  if (isRoot) const Tab(text: "Movimientos MP"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                body: TabBarView(
                  children: [
                    const SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: QuickSale(),
                    ),
                    const SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: SalesRecord(),
                    ),
                    if (isRoot)
                      const SingleChildScrollView(
                        padding: EdgeInsets.all(24),
                        child: MpMovements(),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLeftColumn(bool isRoot) {
    return Column(
      children: [
        SalesRecord(),

        if (isRoot) ...[const SizedBox(height: 16), MpMovements()],
      ],
    );
  }
}
