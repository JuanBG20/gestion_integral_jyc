import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

class LabeledDatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateFormat? dateFormat;

  const LabeledDatePicker({
    super.key,
    required this.label,
    this.value,
    required this.hint,
    required this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final format = dateFormat ?? DateFormat('dd / MM / yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        InkWell(
          onTap: onTap,

          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon:
                  suffixIcon ??
                  const Icon(Icons.calendar_today_outlined, size: 18),
            ),

            child: Text(
              value != null ? format.format(value!) : hint,
              style: context.textTheme.bodyMedium?.copyWith(
                color: value != null
                    ? Colors.black
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
