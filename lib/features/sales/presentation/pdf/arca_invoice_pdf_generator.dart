import 'dart:convert';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/bill_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/bill_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/pdf/emisor_fiscal_data.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ArcaInvoicePdfGenerator {
  static Future<void> previewInvoice(SaleEntity sale) async {
    final bill = sale.bill;
    if (bill == null || !bill.isSuccessful) {
      throw StateError('La venta no tiene una factura emitida.');
    }

    final data = bill.arcaData;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final qrUrl = _buildQrUrl(sale, bill);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(bill),
            pw.SizedBox(height: 10),
            _buildClientBlock(sale, bill),
            pw.SizedBox(height: 10),
            _buildItemsTable(sale.items),
            pw.SizedBox(height: 20),
            _buildTotal(currencyFormat, data.impTotal),
            pw.Spacer(),
            _buildFooter(bill, qrUrl),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Factura_${bill.letraComprobante}_${sale.id ?? "sin-id"}.pdf',
    );
  }

  static String _buildQrUrl(SaleEntity sale, BillEntity bill) {
    final data = bill.arcaData;
    final qrDataMap = {
      "ver": 1,
      "fecha": DateFormat('yyyy-MM-dd').format(data.fechaComprobante),
      "cuit": int.parse(EmisorFiscalData.cuit),
      "ptoVta": data.ptoVta,
      "tipoCmp": data.cbteTipo,
      "nroCmp": data.cbteNro,
      "importe": data.impTotal,
      "moneda": "PES",
      "ctz": 1,
      "tipoDocRec": data.docTipo,
      "nroDocRec": data.docNro,
      "tipoCodAut": "E",
      "codAut": int.tryParse(data.cae) ?? 0,
    };
    final qrBase64 = base64Encode(utf8.encode(jsonEncode(qrDataMap)));
    return 'https://www.arca.gob.ar/fe/qr/?p=$qrBase64';
  }

  static pw.Widget _buildHeader(BillEntity bill) {
    final data = bill.arcaData;

    return pw.Stack(
      alignment: pw.Alignment.topCenter,
      children: [
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 20),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(
                    left: 10,
                    top: 15,
                    bottom: 10,
                    right: 30,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        EmisorFiscalData.razonSocial,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Razón Social: ${EmisorFiscalData.razonSocial}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.Text(
                        'Domicilio Comercial: ${EmisorFiscalData.domicilioComercial}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Condición frente al IVA: ${EmisorFiscalData.condicionIva}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(width: 1, height: 130, color: PdfColors.black),
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(
                    left: 40,
                    top: 15,
                    bottom: 10,
                    right: 10,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FACTURA',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Punto de Venta: ${data.ptoVta.toString().padLeft(5, '0')}  '
                        'Comp. Nro: ${data.cbteNro.toString().padLeft(8, '0')}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Fecha de Emisión: ${data.fechaComprobante.ddMMyyyy}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'CUIT: ${EmisorFiscalData.cuit}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Ingresos Brutos: ${EmisorFiscalData.ingresosBrutos}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.Text(
                        'Fecha de Inicio de Actividades: ${EmisorFiscalData.fechaInicioActividades}',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          width: 45,
          height: 40,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            color: PdfColors.white,
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                bill.letraComprobante,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'COD. ${bill.codigoComprobante}',
                style: const pw.TextStyle(fontSize: 6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildClientBlock(SaleEntity sale, BillEntity bill) {
    final client = sale.client;
    final data = bill.arcaData;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 1, color: PdfColors.black),
          bottom: pw.BorderSide(width: 1, color: PdfColors.black),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (!bill.isConsumidorFinalAnonimo)
                  pw.Text(
                    '${bill.docTipoLabel}: ${data.docNro}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                pw.Text(
                  'Condición frente al IVA: ${bill.condicionIvaReceptorLabel}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text(
                  'Condición de venta: ${sale.paymentMethod.dbValue}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Apellido y Nombre / Razón Social: ${client.fullName}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text(
                  'Domicilio: ${client.formattedAddress}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _itemLabel(SaleItemEntity item) {
    final baseName =
        item.variantProduct?.baseProduct.description ??
        item.description ??
        'Ítem genérico';

    final attributes = [
      item.variantProduct?.color,
      item.variantProduct?.size,
    ].where((a) => a != null && a.trim().isNotEmpty).join(' ');

    return attributes.isEmpty ? baseName : '$baseName ($attributes)';
  }

  static pw.Widget _buildItemsTable(List<SaleItemEntity> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['Descripción', 'Cant.', 'Precio Unit.', 'Subtotal'],
      data: items.map((item) {
        return [
          _itemLabel(item),
          item.quantity.toString(),
          '\$${item.unitPrice.toStringAsFixed(2)}',
          '\$${item.subtotal.toStringAsFixed(2)}',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildTotal(NumberFormat currencyFormat, double total) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 200,
        child: pw.Column(
          children: [
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Importe Total:',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  currencyFormat.format(total),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildFooter(BillEntity bill, String qrUrl) {
    final data = bill.arcaData;

    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(width: 1, color: PdfColors.black)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.BarcodeWidget(
                data: qrUrl,
                barcode: pw.Barcode.qrCode(),
                width: 60,
                height: 60,
              ),
              pw.SizedBox(width: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'ARCA',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                  pw.Text(
                    'AGENCIA DE RECAUDACIÓN',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Y CONTROL ADUANERO',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Comprobante Autorizado',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    'CAE N°: ',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(data.cae, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text(
                    'Fecha de Vto. de CAE: ',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    DateFormat('dd/MM/yyyy').format(data.caeVencimiento),
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
