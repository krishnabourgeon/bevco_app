import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

/// One place for every breakpoint and size rule in the app.
class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  /// Width at which the bill moves into a side panel.
  static const double splitBreakpoint = 840;

  /// Maximum width of page content on very large screens.
  static const double maxContentWidth = 1280;

  static ScreenType typeOf(double width) {
    if (width >= desktopBreakpoint) return ScreenType.desktop;
    if (width >= tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  /// Picks a value by screen width.
  static T value<T>(double width, {required T mobile, T? tablet, T? desktop}) {
    switch (typeOf(width)) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  ScreenType get screenType => Responsive.typeOf(screenWidth);
  bool get isMobile => screenType == ScreenType.mobile;
}