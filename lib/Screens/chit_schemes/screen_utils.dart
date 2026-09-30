import 'package:flutter/material.dart';

/// Screen Utility class for responsive sizing across different screen ratios and dimensions.
/// Base design resolution set to standard 375px width x 812px height.
class ScreenUtil {
  static late MediaQueryData _mediaQueryData;
  static double screenWidth = 375.0;
  static double screenHeight = 812.0;
  static double devicePixelRatio = 1.0;

  // Base design dimensions (Figma / design frame standard)
  static const double baseWidth = 375.0;
  static const double baseHeight = 812.0;

  /// Initialize ScreenUtil at top of build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
  }

  /// Responsive Width based on screen ratio
  static double setWidth(double width) {
    return (width / baseWidth) * screenWidth;
  }

  /// Responsive Height based on screen ratio
  static double setHeight(double height) {
    return (height / baseHeight) * screenHeight;
  }

  /// Responsive Font Size scaled by screen width ratio
  static double setSp(double fontSize) {
    double scale = screenWidth / baseWidth;
    return fontSize * scale;
  }

  /// Percentage of screen width (0 to 100)
  static double widthPercent(double percent) {
    return (percent / 100) * screenWidth;
  }

  /// Percentage of screen height (0 to 100)
  static double heightPercent(double percent) {
    return (percent / 100) * screenHeight;
  }
}

/// Extension on num for concise responsive syntax (e.g. 16.sp, 128.w, 33.h)
extension ScreenUtilExtension on num {
  /// Scaled width
  double get w => ScreenUtil.setWidth(toDouble());

  /// Scaled height
  double get h => ScreenUtil.setHeight(toDouble());

  /// Scaled font size
  double get sp => ScreenUtil.setSp(toDouble());
}
