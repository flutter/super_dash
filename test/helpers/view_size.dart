import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension ViewSize on WidgetTester {
  void setViewSize({
    Size size = const Size(1280, 1024),
  }) {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
  }
}
