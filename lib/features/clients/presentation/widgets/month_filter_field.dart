import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/month_selector.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

// null = Todo el historial
class MonthFilterField extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onChanged;

  const MonthFilterField({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final month = selected;
    final months = selectableMonths();

    return InkWell(
      borderRadius: BorderRadius.circular(2),
      onTap: () async {
        final picked = await showMonthPickerDialog(
          context,
          selected: month ?? currentMonthStart(),
        );
        if (picked != null) onChanged(picked);
      },

      child: InputDecorator(
        isEmpty: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          suffixIcon: month == null
              ? const Icon(Icons.arrow_drop_down)
              : Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    IconButton(
                      tooltip: "Mes anterior",
                      visualDensity: VisualDensity.compact,
                      onPressed: month.isSameMonth(months.last)
                          ? null
                          : () => onChanged(
                              DateTime(month.year, month.month - 1),
                            ),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      tooltip: "Mes siguiente",
                      visualDensity: VisualDensity.compact,
                      onPressed: month.isSameMonth(months.first)
                          ? null
                          : () => onChanged(
                              DateTime(month.year, month.month + 1),
                            ),
                      icon: const Icon(Icons.chevron_right),
                    ),
                    IconButton(
                      tooltip: "Ver todo el historial",
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onChanged(null),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
        ),

        child: Text(
          month == null ? "Todo el historial" : month.monthYearLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge?.copyWith(
            color: month == null
                ? AppColors.onBackground.withValues(alpha: 0.5)
                : null,
          ),
        ),
      ),
    );
  }
}
