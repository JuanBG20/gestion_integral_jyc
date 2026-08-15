import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_searchable_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';

class QuickSale extends ConsumerStatefulWidget {
  const QuickSale({super.key});

  @override
  ConsumerState<QuickSale> createState() => _QuickSaleState();
}

class _QuickSaleState extends ConsumerState<QuickSale> {
  RawMaterialEntity? _selectedMaterial;
  PaymentMethod _selectedMethod = PaymentMethod.efectivo;

  final _productController = TextEditingController();
  final _consumoController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _productController.dispose();
    _consumoController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _selectedMaterial = null;
      _productController.clear();
      _consumoController.clear();
      _amountController.clear();
      _selectedMethod = PaymentMethod.efectivo;
    });
  }

  Future<void> _registerQuickSale() async {
    final productDesc = _productController.text.trim();
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    final consumo = int.tryParse(_consumoController.text) ?? 0;

    if (productDesc.isEmpty || amount <= 0) {
      _showError('Ingrese un producto y un monto válido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final consumidorFinal = _resolveConsumidorFinal();
      if (consumidorFinal == null) {
        _showError('No se encontró el cliente "Consumidor Final"');
        setState(() => _isLoading = false);
        return;
      }

      final newSale = SaleEntity(
        client: consumidorFinal,
        paymentMethod: _selectedMethod,
        date: DateTime.now(),
        finalAmount: amount,
        items: [
          SaleItemEntity(
            quantity: 1,
            unitPrice: amount,
            description: productDesc,
          ),
        ],
        isPaid: true,
      );

      // 2. Guardar la venta en Supabase
      await ref
          .read(saleProvider.notifier)
          .addSale(
            newSale,
            materiaPrimaId: _selectedMaterial?.id,
            consumo: consumo > 0 ? consumo.toDouble() : null,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta Rápida registrada exitosamente')),
      );

      _clearForm();
    } catch (e) {
      _showError('Error al registrar la venta: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsState = ref.watch(rawMaterialProvider);
    final clientsState = ref.watch(clientProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Venta Rápida", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: _productController,
            label: "Producto",
            hint: "Producto Genérico",
          ),

          const SizedBox(height: 16),

          rawMaterialsState.when(
            data: (materials) {
              return LabeledSearchableDropdown<RawMaterialEntity>(
                label: "Material",
                value: _selectedMaterial,
                items: materials,
                itemLabel: (mp) => mp.description,
                hint: "Seleccione una materia prima",
                onChanged: (val) => setState(() => _selectedMaterial = val),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => Text('Error al cargar materias primas: $e'),
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: _consumoController,
            label: "Consumo (g/cm2)",
            inputType: const TextInputType.numberWithOptions(decimal: true),
            hint: "150",
          ),

          const SizedBox(height: 16),

          LabeledTextField(
            controller: _amountController,
            label: "Monto Final",
            inputType: const TextInputType.numberWithOptions(decimal: true),
            hint: "0.00",
          ),

          const SizedBox(height: 16),

          PaymentMethodSelector(
            onMethodChanged: (PaymentMethod value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: _isLoading ? null : _registerQuickSale,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Registrar Venta"),
            ),
          ),
        ],
      ),
    );
  }

  ClientEntity? _resolveConsumidorFinal() {
    final clients = ref.read(clientProvider).value ?? [];
    for (final client in clients) {
      if (client.name == 'Consumidor' && client.lastName == 'Final') {
        return client;
      }
    }
    return null;
  }
}
