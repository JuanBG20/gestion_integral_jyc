import 'package:flutter/material.dart';

class AppMobileList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T items) itemBuilder;

  const AppMobileList({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) => itemBuilder(context, items[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: items.length,
    );
  }
}
