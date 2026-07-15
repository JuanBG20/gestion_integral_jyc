import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/condicion_iva_receptor.dart'
    show CondicionIvaReceptor;
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_date_picker.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/invoice_sale_summary_card.dart';

class NewInvoiceScreen extends ConsumerStatefulWidget {
  final SaleEntity sale;

  const NewInvoiceScreen({super.key, required this.sale});

  @override
  ConsumerState<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends ConsumerState<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  static const List<String> _mockSalePoints = ['0001 - Oficina Central'];
  static const List<String> _mockActivities = ['Venta al por menor y mayor'];

  bool _isLoading = false;

  late final TextEditingController _docNumberController;
  late final TextEditingController _addressController;
  late final PaymentMethod _paymentWay;

  DateTime _issueDate = DateTime.now();
  DocType? _selectedDocType;

  String _concept = "Productos";
  CondicionIvaReceptor _ivaCondition = CondicionIvaReceptor.consumidorFinal;
  String _salePoint = _mockSalePoints.first;
  String _invoiceType = "Factura C";
  String _activity = _mockActivities.first;

  @override
  void initState() {
    super.initState();

    final client = widget.sale.client;

    _selectedDocType = client.docType;
    _docNumberController = TextEditingController(text: client.docNumber ?? '');
    _addressController = TextEditingController(text: client.formattedAddress);
    _paymentWay = widget.sale.paymentMethod;

    _ivaCondition = widget.sale.client.docType == DocType.cuit
        ? CondicionIvaReceptor.responsableInscripto
        : CondicionIvaReceptor.consumidorFinal;
  }

  @override
  void dispose() {
    _docNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickIssueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _issueDate = picked);
    }
  }

  Future<void> _generateInvoice() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final concepto = switch (_concept) {
        'Productos' => 1,
        'Servicios' => 2,
        _ => 3,
      };

      await ref
          .read(saleProvider.notifier)
          .emitInvoice(
            widget.sale.id!,
            condicionIvaReceptorId: _ivaCondition.arcaId,
            concepto: concepto,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura generada con éxito en ARCA')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al facturar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = widget.sale;

    return FormScreenLayout(
      title: "Generar Factura",
      subtitle: "Complete los datos fiscales para emitir la factura en ARCA.",
      returnLabel: "Volver a la Venta",
      saveLabel: _isLoading ? "Generando..." : "Generar Factura (ARCA)",
      formKey: _formKey,
      maxWidth: 1200,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 500;
          final double itemWidth = isWide
              ? (constraints.maxWidth - 24) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                child: Text(
                  "Detalles de la Factura",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDatePicker(
                  label: 'Fecha de Emisión',
                  hint: 'Seleccione una fecha...',
                  onTap: _pickIssueDate,
                  value: _issueDate,
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<String>(
                  label: "Concepto",
                  value: _concept,
                  items:
                      const ["Productos", "Servicios", "Productos y Servicios"]
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _concept = val!),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<PaymentMethod>(
                  label: "Forma de Pago",
                  value: _paymentWay,
                  items: PaymentMethod.values
                      .map(
                        (t) => DropdownMenuItem<PaymentMethod>(
                          value: t,
                          child: Text(t.dbValue),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _paymentWay = val!),
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: Text(
                  "Datos del Cliente",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledDropdown(
                  label: "Tipo de Documento",
                  value: _selectedDocType,
                  hint: "Selecciona un tipo...",
                  items: DocType.values.map((type) {
                    return DropdownMenuItem<DocType>(
                      value: type,
                      child: Text(
                        type.dbValue,
                        style: context.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedDocType = val),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledTextField(
                  controller: _docNumberController,
                  label: "Número de Documento",
                  hint: "46427900",
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<CondicionIvaReceptor>(
                  label: "Condición Frente al IVA",
                  value: _ivaCondition,
                  items: CondicionIvaReceptor.values
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _ivaCondition = val);
                  },
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledTextField(
                  controller: _addressController,
                  label: "Domicilio",
                  hint: "Tucumán 199, Arribeños, Buenos Aires",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: Text(
                  "Opciones Avanzadas",
                  style: context.textTheme.titleMedium,
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<String>(
                  label: "Punto de Venta",
                  value: _salePoint,
                  items: _mockSalePoints
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _salePoint = val!),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<String>(
                  label: "Tipo de Factura",
                  value: _invoiceType,
                  items: const ["Factura A", "Factura B", "Factura C"]
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => _invoiceType = val!),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDropdown<String>(
                  label: "Actividad Asociada",
                  value: _activity,
                  items: _mockActivities
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (val) => setState(() => _activity = val!),
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: InvoiceSaleSummaryCard(sale: sale),

      onReturn: () => Navigator.pop(context),
      onSave: _generateInvoice,
      onCancel: () => Navigator.pop(context),
    );
  }
}
