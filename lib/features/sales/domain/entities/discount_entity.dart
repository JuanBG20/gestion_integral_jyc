import 'package:gestion_integral_jyc/core/enums/discount_origin.dart';

class DiscountEntity {
  final int? id;
  final String reason;
  final double amount;
  final DiscountOrigin origin;
  final double? percentage;

  DiscountEntity({
    required this.reason,
    required this.amount,
    this.id,
    this.origin = DiscountOrigin.otro,
    this.percentage,
  });

  String? get percentageLabel {
    final p = percentage;
    if (p == null) return null;

    final rounded = double.parse(p.toStringAsFixed(2));
    final text = rounded == rounded.truncateToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();

    return '$text%';
  }

  String get displayReason => percentageLabel != null
      ? 'Desc. $reason · $percentageLabel'
      : 'Desc. $reason';
}
