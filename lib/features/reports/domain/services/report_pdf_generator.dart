import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';
import 'package:intl/intl.dart';

class ReportPdfGenerator {
  static Future<Uint8List> generate(
    ReportDashboardEntity dashboard, {
    DateTime? date,
  }) async {
    final pdf = pw.Document();
    final reportDate = date ?? DateTime.now();
    final monthName = DateFormat(
      'MMMM yyyy',
      'es',
    ).format(reportDate).toUpperCase();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            _buildHeader(monthName),
            pw.SizedBox(height: 24),
            _buildGeneralMetrics(dashboard),
            pw.SizedBox(height: 24),
            _buildMonthlyBalance(dashboard),
            pw.SizedBox(height: 24),
            _buildCategoryTable(dashboard),
            pw.SizedBox(height: 24),
            _buildPaymentMethodsTable(dashboard),
            pw.SizedBox(height: 24),
            _buildRegisteredExpensesTable(dashboard),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String monthName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Gestión J&C',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Reporte Financiero',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Período: $monthName',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildGeneralMetrics(ReportDashboardEntity dashboard) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _metricBox(
          'Facturación Total',
          '\$${dashboard.totalInvoiced.toStringAsFixed(0)}',
        ),
        _metricBox(
          'Gastos Totales',
          '\$${dashboard.totalExpenses.toStringAsFixed(0)}',
        ),
        _metricBox(
          'Ganancia Neta',
          '\$${dashboard.netProfit.toStringAsFixed(0)}',
        ),
        _metricBox('Margen Global', '${dashboard.globalMargin}%'),
      ],
    );
  }

  static pw.Widget _metricBox(String title, String value) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMonthlyBalance(ReportDashboardEntity dashboard) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Balance de Flujo de Caja',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Cobrado: \$${dashboard.monthlyCollected.toStringAsFixed(0)}',
                style: const pw.TextStyle(color: PdfColors.green700),
              ),
              pw.Text('-'),
              pw.Text(
                'Pagado: \$${dashboard.monthlyExpenses.toStringAsFixed(0)}',
                style: const pw.TextStyle(color: PdfColors.red700),
              ),
              pw.Text('='),
              pw.Text(
                'Monto Final: \$${dashboard.monthlyFinalAmount.toStringAsFixed(0)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ],
          ),
          if (dashboard.pendingCollection > 0 ||
              dashboard.pendingExpenses > 0) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              'Pendiente de cobro: \$${dashboard.pendingCollection.toStringAsFixed(0)} | Pendiente de pago: \$${dashboard.pendingExpenses.toStringAsFixed(0)}',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColors.orange700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildCategoryTable(ReportDashboardEntity dashboard) {
    final headers = [
      'Categoría',
      'Ventas',
      'Costo Insumos',
      'Ganancia Neta',
      'Margen',
    ];
    final data = dashboard.profitabilityByCategory.map((item) {
      return [
        item.category,
        item.totalSales,
        item.supplyCosts,
        item.netProfit,
        '${item.marginPercent}%',
      ];
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Rentabilidad por Categoría',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey800,
          ),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }

  static pw.Widget _buildPaymentMethodsTable(ReportDashboardEntity dashboard) {
    final headers = ['Método de Pago', 'Operaciones', 'Monto'];
    final data = dashboard.incomeByPaymentMethod.map((item) {
      return [item.leadingText, item.centerText, item.trailingText];
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Ingresos por Método de Pago',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey800,
          ),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }

  static pw.Widget _buildRegisteredExpensesTable(
    ReportDashboardEntity dashboard,
  ) {
    final headers = ['Categoría de Gasto', 'Registros', 'Monto'];
    final data = dashboard.registeredExpenses.map((item) {
      return [item.leadingText, item.centerText, item.trailingText];
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Gastos Registrados',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey800,
          ),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }
}
