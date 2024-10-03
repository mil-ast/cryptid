import 'package:flutter/material.dart';

typedef WindowSize = ({double width, double height});

extension BuildContextExtension on BuildContext {
  WindowSize get windowSize {
    final size = MediaQuery.of(this).size;
    return (width: size.width, height: size.height);
  }

  WindowSize getDialogSize({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
  }) {
    final size = MediaQuery.of(this).size;
    double width = size.width / 2;
    double height = size.height / 2;

    if (minWidth != null && width < minWidth) {
      width = minWidth;
    } else if (maxWidth != null && width > maxWidth) {
      width = maxWidth;
    }

    if (minHeight != null && height < minHeight) {
      height = minHeight;
    } else if (maxHeight != null && height > maxHeight) {
      height = maxHeight;
    }

    return (width: width, height: height);
  }
}
