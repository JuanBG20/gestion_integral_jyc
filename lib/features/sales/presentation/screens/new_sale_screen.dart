import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_items_list_section.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/summary_sale_card.dart';
import 'package:go_router/go_router.dart';

class NewSaleScreen extends ConsumerStatefulWidget {
  const NewSaleScreen({super.key});

  @override
  ConsumerState<NewSaleScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  ClientEntity? _selectedClient;
  List<SaleItemEntity> _currentItems = [];
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  double get _totalAmount =>
      _currentItems.fold(0, (sum, item) => sum + item.subtotal);

  void _saveSale() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar un cliente')),
        );
        return;
      }
      if (_currentItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe agregar al menos un producto')),
        );
        return;
      }

      final newSale = SaleEntity(
        client: _selectedClient!,
        date: DateTime.now(),
        finalAmount: _totalAmount,
        paymentMethod: _selectedMethod,
        items: _currentItems,
      );

      ref
          .read(saleProvider.notifier)
          .addSale(newSale)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Venta registrada exitosamente')),
            );
            context.go('/sales');
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientProvider);

    return FormScreenLayout(
      title: "Registrar Venta",
      subtitle: "Complete los detalles para registrar una nueva venta.",
      returnLabel: "Volver a Ventas",
      saveLabel: "Guardar Venta",
      maxWidth: 1200,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 24,
            runSpacing: 24,

            children: [
              SizedBox(
                width: constraints.maxWidth,

                child: clientsState.when(
                  data: (clients) {
                    return LabeledDropdown(
                      label: "Cliente",
                      value: _selectedClient,
                      items: clients
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c.fullName,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      hint: "Seleccione un cliente",
                      onChanged: (val) => setState(() => _selectedClient = val),
                      validator: (value) => value == null ? 'Requerido' : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error al cargar clientes: $e'),
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: SaleItemsListSection(
                  onItemsChanged: (items) {
                    setState(() {
                      _currentItems = items;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: SummarySaleCard(
        currentItems: _currentItems,
        onPaymentMethodChange: (method) {
          setState(() {
            _selectedMethod = method;
          });
        },
      ),

      onReturn: () {
        context.go('/sales');
      },
      onSave: _saveSale,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
