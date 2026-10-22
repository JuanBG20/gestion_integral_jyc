import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/summary_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/history/expenses_history_tab_wrapper.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/templates/expense_templates_tab_wrapper.dart';
import 'package:go_router/go_router.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return DefaultTabController(
      length: 2,

      child: Builder(
        builder: (tabContext) {
          return Scaffold(
            backgroundColor: AppColors.surface,

            floatingActionButton: context.isMobileLayout
                ? FloatingActionButton(
                    heroTag: "btn_main_expenses",
                    onPressed: () => _newItemNavigation(tabContext, ref),
                    child: const Icon(Icons.add),
                  )
                : null,

            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          ScreenHeader(
                            title: "Gastos",
                            subtitle:
                                "Registrá gastos operativos, servicios recurrentes y compras de suministros.",
                            buttonLabel: "Nuevo Gasto",
                            onPressed: () =>
                                _newItemNavigation(tabContext, ref),
                            hasButtons: true,
                          ),

                          const SizedBox(height: 24),

                          /* SaleFilters(
                      selectedState: selectedState,
                      selectedMethod: selectedMethod,
                                        ), */
                          const SizedBox(height: 32),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardWidth = constraints.maxWidth < 400
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth / 3) - 11;

                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,

                                children: [
                                  SummaryCard(
                                    width: cardWidth,
                                    title: 'TOTAL GASTADO',
                                    value: '\$184200',
                                    subtitle: '+12.4% vs. mes anterior',
                                    icon: Icons.receipt_long_outlined,
                                    iconColor: AppColors.primary,
                                    onTap: () => context.go('/sales'),
                                  ),

                                  SummaryCard(
                                    width: cardWidth,
                                    title: 'TOTAL PENDIENTE DE PAGO',
                                    value: '\$43200',
                                    subtitle: '2 facturas por vencer',
                                    icon: Icons.alarm_outlined,
                                    iconColor: AppColors.error,
                                    onTap: () => context.go('/work'),
                                  ),

                                  SummaryCard(
                                    width: cardWidth,
                                    title: 'MONTO DE GASTOS FIJOS',
                                    value: '\$78500',
                                    subtitle: 'Valores fijos',
                                    icon: Icons.replay_outlined,
                                    iconColor: Colors.deepPurple,
                                    onTap: () => context.go('/inventory'),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                        ],
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
                          tabs: [
                            const Tab(text: "Historial de Gastos"),
                            const Tab(
                              text: "Subscripciones y Gastos Recurrentes",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },

              body: TabBarView(
                children: [
                  ExpensesHistoryTabWrapper(isAdmin: isAdmin),
                  ExpenseTemplatesTabWrapper(isAdmin: isAdmin),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _newItemNavigation(BuildContext tabContext, WidgetRef ref) {
    final currentIndex = DefaultTabController.of(tabContext).index;

    switch (currentIndex) {
      case 0:
        tabContext.push('/expenses/new');
        break;
      case 1:
        tabContext.push('/expenses/new-template');
        break;
    }
  }
}
