import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/responsive_filter_bar.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_filter_providers.dart';

class SaleFilters extends ConsumerWidget {
  final String? selectedState;
  final PaymentMethod? selectedMethod;

  const SaleFilters({
    super.key,
    required this.selectedState,
    required this.selectedMethod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveFilterBar(
      filters: [_buildStateFilter(ref), _buildPaymentFilter(ref)],
    );
  }

  Widget _buildStateFilter(WidgetRef ref) {
    return LabeledDropdown<String?>(
      label: 'Filtrar por Estado',
      value: selectedState,
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Todos los estados'),
        ),
        const DropdownMenuItem<String?>(
          value: 'withoutBill',
          child: Text('Sin facturar'),
        ),
        const DropdownMenuItem<String?>(
          value: 'withoutPayment',
          child: Text('Pendientes de pago'),
        ),
      ],
      onChanged: (String? state) {
        ref.read(saleStateFilterProvider.notifier).state = state;
      },
    );
  }

  Widget _buildPaymentFilter(WidgetRef ref) {
    return LabeledDropdown<PaymentMethod?>(
      label: 'Filtrar por Medio de Pago',
      value: selectedMethod,
      items: [
        const DropdownMenuItem<PaymentMethod?>(
          value: null,
          child: Text('Todos los medios de pago'),
        ),
        ...PaymentMethod.values.map(
          (method) => DropdownMenuItem<PaymentMethod?>(
            value: method,
            child: Text(method.dbValue),
          ),
        ),
      ],
      onChanged: (PaymentMethod? method) {
        ref.read(salePaymentMethodFilterProvider.notifier).state = method;
      },
    );
  }
}
