import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';

class BreakdownRowModel extends BreakdownRowItemEntity {
  const BreakdownRowModel({
    super.icon,
    required super.leadingText,
    required super.centerText,
    required super.trailingText,
    super.trailingColor,
  });

  factory BreakdownRowModel.fromJson(Map<String, dynamic> json) {
    return BreakdownRowModel(
      leadingText: json['leading_text'] ?? '',
      centerText: json['center_text']?.toString() ?? '',
      trailingText: json['trailing_text'] ?? '',
    );
  }
}
