import 'package:flutter/material.dart';

class BreakdownRowItemEntity {
  final IconData? icon;
  final String leadingText;
  final String centerText;
  final String trailingText;
  final Color? trailingColor;

  const BreakdownRowItemEntity({
    this.icon,
    required this.leadingText,
    required this.centerText,
    required this.trailingText,
    this.trailingColor,
  });
}
