import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/address_formatting.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BudgetPdfGenerator {
  static Future<void> generateAndPreviewBudget(WorkEntity work) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(work),
            pw.SizedBox(height: 24),
            _buildClientInfo(work.client),
            pw.SizedBox(height: 32),
            _buildItemsTable(work.items),
            pw.SizedBox(height: 16),
            _buildTotal(work.items),
            pw.SizedBox(height: 32),
            _buildFooter(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "Presupuesto_JyC_${work.id ?? 'sin-id'}.pdf",
    );
  }

  static pw.Widget _buildHeader(WorkEntity work) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'PRESUPUESTO',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.Text('Documento no válido como factura'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'J&C Impresiones 3D',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            ),
            pw.Text('Nº de Referencia: TRB-${work.id ?? '---'}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildClientInfo(ClientEntity client) {
    final doc = client.docType != null && client.docNumber != null
        ? '${client.docType!.dbValue} ${client.docNumber}'
        : 'No especificado';

    final address = client.formattedAddress;

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DATOS DEL CLIENTE',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Nombre: ${client.fullName}'),
          pw.Text('Documento: $doc'),
          pw.Text('Dirección: $address'),
        ],
      ),
    );
  }

  static String _itemLabel(WorkItemEntity item) {
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

  static pw.Widget _buildItemsTable(List<WorkItemEntity> items) {
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
      border: null,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
    );
  }

  static pw.Widget _buildTotal(List<WorkItemEntity> items) {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            'TOTAL ESTIMADO: ',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '\$${total.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.Text(
          'Los precios están sujetos a modificaciones sin previo aviso. Este presupuesto tiene una validez de 15 días.',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}
