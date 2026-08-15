import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/condicion_iva_receptor.dart'
    show CondicionIvaReceptor;
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_date_picker.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_movement_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/invoice_sale_summary_card.dart';

class NewInvoiceScreen extends ConsumerStatefulWidget {
  final SaleEntity sale;
  final int? mpMovementId;

  const NewInvoiceScreen({super.key, required this.sale, this.mpMovementId});

  @override
  ConsumerState<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends ConsumerState<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  late final TextEditingController _docTypeController;
  late final TextEditingController _docNumberController;
  late final TextEditingController _addressController;
  late final TextEditingController _paymentWayController;

  DateTime _issueDate = DateTime.now();

  String _concept = "Productos";
  CondicionIvaReceptor _ivaCondition = CondicionIvaReceptor.consumidorFinal;

  @override
  void initState() {
    super.initState();

    final client = widget.sale.client;

    _docTypeController = TextEditingController(
      text: client.docType?.dbValue ?? '',
    );
    _docNumberController = TextEditingController(text: client.docNumber ?? '');
    _addressController = TextEditingController(text: client.formattedAddress);
    _paymentWayController = TextEditingController(
      text: widget.sale.paymentMethod!.dbValue,
    );

    _ivaCondition = widget.sale.client.docType == DocType.cuit
        ? CondicionIvaReceptor.responsableInscripto
        : CondicionIvaReceptor.consumidorFinal;
  }

  @override
  void dispose() {
    _docTypeController.dispose();
    _docNumberController.dispose();
    _addressController.dispose();
    _paymentWayController.dispose();
    super.dispose();
  }

  (DateTime, DateTime) _allowedDateRange() {
    final int days = _concept == 'Productos' ? 5 : 10;
    final today = DateTime.now();
    final min = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: days));
    final max = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(Duration(days: days));
    return (min, max);
  }

  void _clampIssueDateToAllowedRange() {
    final (min, max) = _allowedDateRange();
    if (_issueDate.isBefore(min)) {
      setState(() => _issueDate = min);
    } else if (_issueDate.isAfter(max)) {
      setState(() => _issueDate = max);
    }
  }

  Future<void> _pickIssueDate() async {
    final (min, max) = _allowedDateRange();

    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate.isBefore(min)
          ? min
          : (_issueDate.isAfter(max) ? max : _issueDate),
      firstDate: min,
      lastDate: max,
      helpText: _concept == 'Productos'
          ? 'AFIP permite hasta 5 días de diferencia'
          : 'AFIP permite hasta 10 días de diferencia',
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

      int? currentSaleId = widget.sale.id;
      if (currentSaleId == null) {
        final savedSale = await ref
            .read(saleProvider.notifier)
            .createSale(widget.sale);
        currentSaleId = savedSale.id;

        if (widget.mpMovementId != null && currentSaleId != null) {
          await ref
              .read(mpMovementsProvider.notifier)
              .linkToSale(widget.mpMovementId!, currentSaleId);
        }
      }

      await ref
          .read(saleProvider.notifier)
          .emitInvoice(
            currentSaleId!,
            condicionIvaReceptorId: _ivaCondition.arcaId,
            concepto: concepto,
            issueDate: _issueDate,
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
                  onChanged: (val) {
                    setState(() => _concept = val!);
                    _clampIssueDateToAllowedRange();
                  },
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledTextField(
                  controller: _paymentWayController,
                  label: "Forma de Pago",
                  hint: "",
                  readOnly: true,
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
                child: LabeledTextField(
                  controller: _docTypeController,
                  label: "Tipo de Documento",
                  hint: "",
                  readOnly: true,
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledTextField(
                  controller: _docNumberController,
                  label: "Número de Documento",
                  hint: "",
                  readOnly: true,
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
                  hint: "",
                  readOnly: true,
                ),
              ),

              /* Divider(color: AppColors.outline),

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
                  label: "Actividad Asociada",
                  value: _activity,
                  items: _mockActivities
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (val) => setState(() => _activity = val!),
                ),
              ), */
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
