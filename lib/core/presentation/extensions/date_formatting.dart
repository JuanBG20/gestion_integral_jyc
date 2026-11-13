import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);
  String get mmmDd => DateFormat('MMM. dd', 'es').format(this);

  String get monthYearLabel {
    final label = DateFormat('MMMM yyyy', 'es').format(this);
    return label.isEmpty ? label : label[0].toUpperCase() + label.substring(1);
  }
}

extension MonthRange on DateTime {
  DateTime get monthStart => DateTime(year, month);
  DateTime get nextMonthStart => DateTime(year, month + 1);

  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;
}

DateTime currentMonthStart() => DateTime.now().monthStart;
