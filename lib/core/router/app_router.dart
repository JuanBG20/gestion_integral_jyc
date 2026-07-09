import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/clients_screen.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/layout.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_screen.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/screens/sales_screen.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/work',
              builder: (context, state) => const WorkScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              builder: (context, state) => const SalesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clients',
              builder: (context, state) => const ClientsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
