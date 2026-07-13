import 'package:flutter/material.dart';

extension ScreenSizeX on BuildContext {
  bool get isMobileLayout => MediaQuery.of(this).size.width < 600;
}

extension BoxConstraintsX on BoxConstraints {
  bool get isMobileLayout => maxWidth < 600;
  bool get isDesktopLayout => maxWidth > 840;
}
