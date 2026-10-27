import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/payment_method_discount_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/payment_method_discount_provider.dart';

class PaymentMethodDiscountsSection extends ConsumerWidget {
  const PaymentMethodDiscountsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discounts = ref.watch(paymentMethodDiscountsProvider);

    return discounts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('No se pudieron cargar los descuentos'),
      data: (items) => Column(
        children: [
          for (final d in items)
            _PaymentMethodDiscountTile(key: ValueKey(d.method), discount: d),
        ],
      ),
    );
  }
}

class _PaymentMethodDiscountTile extends ConsumerStatefulWidget {
  final PaymentMethodDiscountEntity discount;

  const _PaymentMethodDiscountTile({super.key, required this.discount});

  @override
  ConsumerState<_PaymentMethodDiscountTile> createState() =>
      _PaymentMethodDiscountTileState();
}

class _PaymentMethodDiscountTileState
    extends ConsumerState<_PaymentMethodDiscountTile> {
  late final _controller = TextEditingController(
    text: _format(widget.discount.percentage),
  );
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _savePercentage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _format(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 2);

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _save(PaymentMethodDiscountEntity updated) async {
    try {
      await ref.read(paymentMethodDiscountsProvider.notifier).save(updated);
    } catch (_) {
      if (!mounted) return;
      _controller.text = _format(widget.discount.percentage);
      _showError('No se pudo guardar el descuento');
    }
  }

  void _savePercentage() {
    final value = double.tryParse(_controller.text.replaceAll(',', '.'));

    if (value == null || value < 0 || value > 100) {
      _showError('Ingresá un porcentaje entre 0 y 100');
      _controller.text = _format(widget.discount.percentage);
      return;
    }

    if (value == widget.discount.percentage) return;
    _save(widget.discount.copyWith(percentage: value));
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.discount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Switch(
            value: d.applies,
            onChanged: (value) => _save(d.copyWith(applies: value)),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(d.method.dbValue, style: context.textTheme.bodyMedium),
          ),

          SizedBox(
            width: 120,
            child: LabeledTextField(
              controller: _controller,
              focusNode: _focusNode,
              label: "Descuento (%)",
              hint: "0",
              inputType: const TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: (_) => _savePercentage(),
            ),
          ),
        ],
      ),
    );
  }
}
