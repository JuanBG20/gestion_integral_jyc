import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/screens/login_screen.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/screens/register_screen.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/layout.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/clients_screen_wrapper.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/new_client_screen.dart';
import 'package:gestion_integral_jyc/features/config/presentation/screens/config_screen.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/screens/new_expense_screen.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/screens/new_expense_template_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_product_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_raw_material_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_scrap_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/price_update_preview_screen.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/all_works_screen_wrapper.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/new_work_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_adaptative_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_details_screen.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/screens/reports_screen.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/all_sales_screen_wrapper.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/new_invoice_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/new_sale_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/sale_details_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/sales_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/scanner_screen.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/screens/windows_paywall_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final bool _isAnalyticsSupported =
    kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  observers: [
    if (_isAnalyticsSupported)
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isAuthRoute) return '/login';
    if (isLoggedIn && isAuthRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'LoginScreen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'RegisterScreen',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/scanner',
      name: 'ScannerScreen',
      builder: (context, state) => const ScannerScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Layout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'DashboardScreen',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              name: 'InventoryScreen',
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'new-material',
                  name: 'NewRawMaterialScreen',
                  builder: (context, state) => const NewRawMaterialScreen(),
                ),
                GoRoute(
                  path: 'edit-material',
                  name: 'EditRawMaterialScreen',
                  builder: (context, state) {
                    final material = state.extra as RawMaterialEntity;
                    return NewRawMaterialScreen(rawMaterialToEdit: material);
                  },
                ),

                GoRoute(
                  path: 'new-product',
                  name: 'NewProductScreen',
                  builder: (context, state) => const NewProductScreen(),
                ),
                GoRoute(
                  path: 'edit-product',
                  name: 'EditProductScreen',
                  builder: (context, state) {
                    final product = state.extra as ProductGroupUi;
                    return NewProductScreen(productToEdit: product);
                  },
                ),

                GoRoute(
                  path: 'new-scrap',
                  name: 'NewScrapScreen',
                  builder: (context, state) => const NewScrapScreen(),
                ),
                GoRoute(
                  path: 'edit-scrap',
                  name: 'EditScrapScreen',
                  builder: (context, state) {
                    final scrap = state.extra as ScrapEntity;
                    return NewScrapScreen(scrapToEdit: scrap);
                  },
                ),

                GoRoute(
                  path: 'price-preview',
                  name: 'PricePreviewScreen',
                  builder: (context, state) => const PriceUpdatePreviewScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/work',
              name: 'WorkScreen',
              builder: (context, state) => const WorkAdaptativeScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'NewWorkScreen',
                  builder: (context, state) => const NewWorkScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  name: 'EditWorkScreen',
                  builder: (context, state) {
                    final work = state.extra as WorkEntity;
                    return NewWorkScreen(workToEdit: work);
                  },
                ),
                GoRoute(
                  path: 'detail',
                  name: 'WorkDetailsScreen',
                  builder: (context, state) {
                    final work = state.extra as WorkEntity;
                    return WorkDetailsScreen(initialWork: work);
                  },
                ),
                GoRoute(
                  path: 'all',
                  name: 'AllWorksScreen',
                  builder: (context, state) => const AllWorksScreenWrapper(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              name: 'SalesScreen',
              builder: (context, state) => const SalesScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'NewSaleScreen',
                  builder: (context, state) => const NewSaleScreen(),
                ),
                GoRoute(
                  path: 'all',
                  name: 'AllSalesScreen',
                  builder: (context, state) => const AllSalesScreenWrapper(),
                ),
                GoRoute(
                  path: 'detail',
                  name: 'SaleDetailsScreen',
                  builder: (context, state) {
                    final sale = state.extra as SaleEntity;
                    return SaleDetailsScreen(sale: sale);
                  },
                  routes: [
                    GoRoute(
                      path: 'bill',
                      name: 'BillScreen',
                      builder: (context, state) {
                        final sale = state.extra as SaleEntity;
                        final mpMovementId = int.tryParse(
                          state.uri.queryParameters['mpMovementId'] ?? '',
                        );

                        return NewInvoiceScreen(
                          sale: sale,
                          mpMovementId: mpMovementId,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              name: 'ReportsScreen',
              builder: (context, state) => const ReportsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clients',
              name: 'ClientsScreen',
              builder: (context, state) => const ClientsScreenWrapper(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'NewClientScreen',
                  builder: (context, state) => const NewClientScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  name: 'EditClientScreen',
                  builder: (context, state) {
                    final client = state.extra as ClientEntity;
                    return NewClientScreen(clientToEdit: client);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              name: 'ExpensesScreen',
              builder: (context, state) => const ExpensesScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'NewExpenseScreen',
                  builder: (context, state) => const NewExpenseScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  name: 'EditExpenseScreen',
                  builder: (context, state) {
                    if (state.extra is ExpenseEntity) {
                      return NewExpenseScreen(
                        expenseToEdit: state.extra as ExpenseEntity,
                      );
                    }

                    return const ExpensesScreen();
                  },
                ),
                GoRoute(
                  path: 'detail',
                  name: 'ExpenseDetailsScreen',
                  builder: (context, state) {
                    if (state.extra is ExpenseEntity) {
                      return ExpenseDetailsScreen(
                        initialExpense: state.extra as ExpenseEntity,
                      );
                    }

                    return const ExpensesScreen();
                  },
                ),

                GoRoute(
                  path: 'new-template',
                  name: 'NewExpenseTemplateScreen',
                  builder: (context, state) => const NewExpenseTemplateScreen(),
                ),
                GoRoute(
                  path: 'edit-template',
                  name: 'EditExpenseTemplateScreen',
                  builder: (context, state) {
                    if (state.extra is ExpenseTemplateEntity) {
                      return NewExpenseTemplateScreen(
                        templateToEdit: state.extra as ExpenseTemplateEntity,
                      );
                    }

                    return const ExpensesScreen();
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/config',
              name: 'ConfigScreen',
              builder: (context, state) => const ConfigScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/subscriptions',
              name: 'SubscriptionsScreen',
              builder: (context, state) => const Placeholder(),
              routes: [
                GoRoute(
                  path: 'windows',
                  builder: (context, state) => const WindowsPaywallScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
