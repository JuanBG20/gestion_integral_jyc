import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/screens/login_screen.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/clients_screen.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/layout.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/screens/new_client_screen.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_product_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_raw_material_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/new_scrap_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/price_update_preview_screen.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/all_works_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/new_work_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_adaptative_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_details_screen.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/all_sales_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/new_invoice_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/new_sale_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/sale_details_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/sales_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/scanner_screen.dart';
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

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    final isLoggingIn = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoggingIn) return '/login';
    if (isLoggedIn && isLoggingIn) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/scanner',
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
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'new-material',
                  builder: (context, state) => const NewRawMaterialScreen(),
                ),
                GoRoute(
                  path: 'edit-material',
                  builder: (context, state) {
                    final material = state.extra as RawMaterialEntity;
                    return NewRawMaterialScreen(rawMaterialToEdit: material);
                  },
                ),

                GoRoute(
                  path: 'new-product',
                  builder: (context, state) => const NewProductScreen(),
                ),
                GoRoute(
                  path: 'edit-product',
                  builder: (context, state) {
                    final product = state.extra as ProductGroupUi;
                    return NewProductScreen(productToEdit: product);
                  },
                ),

                GoRoute(
                  path: 'new-scrap',
                  builder: (context, state) => const NewScrapScreen(),
                ),
                GoRoute(
                  path: 'edit-scrap',
                  builder: (context, state) {
                    final scrap = state.extra as ScrapEntity;
                    return NewScrapScreen(scrapToEdit: scrap);
                  },
                ),

                GoRoute(
                  path: 'price-preview',
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
              builder: (context, state) => const WorkAdaptativeScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const NewWorkScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final work = state.extra as WorkEntity;
                    return NewWorkScreen(workToEdit: work);
                  },
                ),
                GoRoute(
                  path: 'detail',
                  builder: (context, state) {
                    final work = state.extra as WorkEntity;
                    return WorkDetailsScreen(initialWork: work);
                  },
                ),
                GoRoute(
                  path: 'all',
                  builder: (context, state) => const AllWorksScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              builder: (context, state) => const SalesScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const NewSaleScreen(),
                ),
                GoRoute(
                  path: 'all',
                  builder: (context, state) => const AllSalesScreen(),
                ),
                GoRoute(
                  path: 'detail',
                  builder: (context, state) {
                    final sale = state.extra as SaleEntity;
                    return SaleDetailsScreen(sale: sale);
                  },
                  routes: [
                    GoRoute(
                      path: 'bill',
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
              path: '/clients',
              builder: (context, state) => const ClientsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const NewClientScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final client = state.extra as ClientEntity;
                    return NewClientScreen(clientToEdit: client);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
