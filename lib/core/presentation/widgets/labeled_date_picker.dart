import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

class LabeledDatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String hint;
  final ValueChanged<DateTime> onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateFormat? dateFormat;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helpText;

  const LabeledDatePicker({
    super.key,
    required this.label,
    this.value,
    required this.hint,
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.helpText,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime initial = value ?? DateTime.now();

    if (firstDate != null && initial.isBefore(firstDate!)) {
      initial = firstDate!;
    } else if (lastDate != null && initial.isAfter(lastDate!)) {
      initial = lastDate!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

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
          onTap: () => _pickDate(context),

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
