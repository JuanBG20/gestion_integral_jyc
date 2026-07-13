import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/mp_movements.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/quick_sale.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sales_record.dart';
import 'package:go_router/go_router.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
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

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.isDesktopLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 6, child: _buildLeftColumn(context)),

                      const SizedBox(width: 24),

                      Expanded(flex: 4, child: QuickSale()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftColumn(context),
                      const SizedBox(height: 24),
                      QuickSale(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      children: [SalesRecord(), const SizedBox(height: 16), MpMovements()],
    );
  }
}
