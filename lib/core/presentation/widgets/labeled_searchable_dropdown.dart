import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LabeledSearchableDropdown<T extends Object> extends StatefulWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? Function(T?)? validator;

  const LabeledSearchableDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  State<LabeledSearchableDropdown<T>> createState() =>
      _LabeledSearchableDropdownState<T>();
}

class _LabeledSearchableDropdownState<T extends Object>
    extends State<LabeledSearchableDropdown<T>> {
  TextEditingController? _controller;

  @override
  void didUpdateWidget(covariant LabeledSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el valor cambia desde afuera, sincronizamos el texto mostrado.
    if (widget.value != oldWidget.value && _controller != null) {
      _controller!.text = widget.value != null
          ? widget.itemLabel(widget.value as T)
          : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          widget.label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        FormField<T>(
          initialValue: widget.value,
          validator: widget.validator,
          builder: (state) {
            return Autocomplete<T>(
              initialValue: TextEditingValue(
                text: widget.value != null
                    ? widget.itemLabel(widget.value as T)
                    : '',
              ),
              displayStringForOption: widget.itemLabel,
              optionsBuilder: (textValue) {
                if (textValue.text.isEmpty) return widget.items;

                final query = textValue.text.toLowerCase();
                return widget.items.where(
                  (item) =>
                      widget.itemLabel(item).toLowerCase().contains(query),
                );
              },
              onSelected: (selected) {
                widget.onChanged(selected);
                state.didChange(selected);
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,

                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(4),

                    child: Container(
                      width: 400,
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.outline),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              widget.itemLabel(option),
                              style: context.textTheme.bodyMedium,
                            ),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    _controller = controller;

                    if (controller.text.isEmpty && widget.value != null) {
                      controller.text = widget.itemLabel(widget.value as T);
                    }
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        errorText: state.errorText,
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                    );
                  },
            );
          },
        ),
      ],
    );
  }
}
