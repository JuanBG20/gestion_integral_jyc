import 'package:flutter/material.dart';

class AppMobileList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T items) itemBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const AppMobileList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.zero,

      shrinkWrap: shrinkWrap,
      physics: physics,

      itemBuilder: (context, index) => itemBuilder(context, items[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: items.length,
    );
  }
}
