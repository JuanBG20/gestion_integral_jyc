import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

// Cantidad de meses hacia atrás que se pueden elegir
const int kSelectableMonthsBack = 36;

List<DateTime> selectableMonths() {
  final current = currentMonthStart();
  return List.generate(
    kSelectableMonthsBack + 1,
    (i) => DateTime(current.year, current.month - i),
  );
}

String monthButtonLabel(DateTime month) =>
    month.isSameMonth(DateTime.now()) ? "Este Mes" : month.monthYearLabel;

// Abre un diálogo para elegir un mes
Future<DateTime?> showMonthPickerDialog(
  BuildContext context, {
  required DateTime selected,
}) {
  final months = selectableMonths();

  return showDialog<DateTime>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Elegir mes", style: context.textTheme.titleLarge),
      content: SizedBox(
        width: 320,
        height: 400,
        child: ListView.builder(
          itemCount: months.length,
          itemBuilder: (context, index) {
            final month = months[index];
            final isSelected = month.isSameMonth(selected);
            return ListTile(
              title: Text(month.monthYearLabel),
              subtitle: index == 0 ? const Text("Mes actual") : null,
              selected: isSelected,
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop(month),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
      ],
    ),
  );
}

// Selector compacto de mes
class MonthSelector extends StatelessWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onChanged;

  const MonthSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final months = selectableMonths();
    final isCurrent = selected.isSameMonth(months.first);
    final isOldest = selected.isSameMonth(months.last);

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        IconButton(
          tooltip: "Mes anterior",
          visualDensity: VisualDensity.compact,
          onPressed: isOldest
              ? null
              : () => onChanged(DateTime(selected.year, selected.month - 1)),
          icon: const Icon(Icons.chevron_left),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            final picked = await showMonthPickerDialog(
              context,
              selected: selected,
            );
            if (picked != null) onChanged(picked);
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),

                const SizedBox(width: 6),

                Text(
                  isCurrent ? "Este mes" : selected.monthYearLabel,
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),

        IconButton(
          tooltip: "Mes siguiente",
          visualDensity: VisualDensity.compact,
          onPressed: isCurrent
              ? null
              : () => onChanged(DateTime(selected.year, selected.month + 1)),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
