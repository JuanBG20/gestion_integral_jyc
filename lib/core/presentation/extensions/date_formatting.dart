import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);
  String get mmmDd => DateFormat('MMM. dd', 'es').format(this);
}
