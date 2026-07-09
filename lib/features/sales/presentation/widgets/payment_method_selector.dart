import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Medio de Pago",
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 80,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          children: [
            _buildOptionCard(
              method: PaymentMethod.efectivo,
              icon: Icons.payments_outlined,
              label: "Efectivo",
            ),

            _buildOptionCard(
              method: PaymentMethod.transferencia,
              icon: Icons.account_balance_outlined,
              label: "Transferencia",
            ),

            _buildOptionCard(
              method: PaymentMethod.qr,
              icon: Icons.qr_code_2,
              label: "QR",
            ),

            _buildOptionCard(
              method: PaymentMethod.tarjeta,
              icon: Icons.credit_card_outlined,
              label: "Tarjeta",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required PaymentMethod method,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedMethod == method;

    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.outline;
    final activeTextColor = Colors.white;
    final inactiveTextColor = AppColors.onBackground;

    return Material(
      color: isSelected ? activeColor : Colors.transparent,
      borderRadius: BorderRadius.circular(4),

      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(4),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? Colors.transparent : inactiveColor,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? activeTextColor : inactiveTextColor,
                size: 28,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? activeTextColor : inactiveTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
