import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_segment_button.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LabeledSegmentButton<T> extends StatelessWidget {
  final String label;
  final T groupValue;
  final ValueChanged<T> onChanged;

  final String leftTitle;
  final IconData leftIcon;
  final T leftValue;

  final String rightTitle;
  final IconData rightIcon;
  final T rightValue;

  const LabeledSegmentButton({
    super.key,
    required this.label,
    required this.groupValue,
    required this.onChanged,
    required this.leftTitle,
    required this.leftIcon,
    required this.leftValue,
    required this.rightTitle,
    required this.rightIcon,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
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

        Row(
          children: [
            Expanded(
              child: AppSegmentButton(
                title: leftTitle,
                icon: leftIcon,
                isSelected: groupValue == leftValue,
                onTap: () => onChanged(leftValue),
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: AppSegmentButton(
                title: rightTitle,
                icon: rightIcon,
                isSelected: groupValue == rightValue,
                onTap: () => onChanged(rightValue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
