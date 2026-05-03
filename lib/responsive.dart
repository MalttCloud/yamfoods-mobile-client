import 'package:flutter/material.dart';

extension ResponsiveX on BuildContext {
  static const double _tabletBreakpoint = 600;
  static const double _tabletPortraitBreakpoint = 900;

  bool get isTablet => MediaQuery.sizeOf(this).width >= _tabletBreakpoint;

  bool get isTabletInPortraitMOde =>
      MediaQuery.sizeOf(this).width >= _tabletPortraitBreakpoint;
}