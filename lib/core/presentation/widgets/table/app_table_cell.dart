import 'package:flutter/material.dart';

class AppTableCell {
  final int flex;
  final Widget child;

  AppTableCell({required this.flex, required this.child});

  factory AppTableCell.text(
    String text, {
    required int flex,
    TextStyle? style,
  }) {
    return AppTableCell(
      flex: flex,
      child: Text(text, style: style),
    );
  }

  factory AppTableCell.field({
    required int flex,
    required TextEditingController controller,
    String? hint,
  }) {
    return AppTableCell(
      flex: flex,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
