import 'package:flutter/material.dart';

/// MediaQuery size extensions for easy access to screen dimensions
extension MediaQuerySizeExtension on BuildContext {
  /// Get MediaQuery of the context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width
  double get screenWidth => mediaQuery.size.width;

  /// Screen height
  double get screenHeight => mediaQuery.size.height;

  /// Screen aspect ratio
  double get screenAspectRatio => mediaQuery.size.aspectRatio;

  /// Screen diagonal (pythagorean theorem)
  double get screenDiagonal =>
      (screenWidth * screenWidth + screenHeight * screenHeight) /
      (screenWidth + screenHeight);

  /// Check if screen is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if screen is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Status bar height
  double get statusBarHeight => mediaQuery.padding.top;

  /// Bottom padding (safe area)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// App bar height (default)
  double get appBarHeight => kToolbarHeight;

  /// Available height (screen height - status bar - app bar)
  double get availableHeight =>
      screenHeight - statusBarHeight - appBarHeight - bottomPadding;

  /// Available width
  double get availableWidth => screenWidth;

  /// Padding (all sides)
  EdgeInsets get padding => mediaQuery.padding;

  /// View padding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// View insets
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Text scale factor (deprecated, use textScaler)
  @Deprecated('Use textScaler instead')
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// Text scaler
  TextScaler get textScaler => mediaQuery.textScaler;

  /// Device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Brightness
  Brightness get brightness => mediaQuery.platformBrightness;

  /// Check if device is tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  /// Check if device is phone
  bool get isPhone => !isTablet;

  /// Check if device is small phone (width < 360)
  bool get isSmallPhone => screenWidth < 360;

  /// Check if device is large phone (width > 400)
  bool get isLargePhone => screenWidth > 400 && !isTablet;
}

/// Responsive size extensions
extension ResponsiveSizeExtension on BuildContext {
  /// Get responsive width percentage
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Get responsive height percentage
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Get responsive size based on screen width
  double responsiveWidth(double value) {
    final designWidth = 375.0; // iPhone X design width
    return (value / designWidth) * screenWidth;
  }

  /// Get responsive size based on screen height
  double responsiveHeight(double value) {
    final designHeight = 812.0; // iPhone X design height
    return (value / designHeight) * screenHeight;
  }

  /// Get responsive font size
  double responsiveFontSize(double fontSize) {
    final scale = screenWidth / 375.0; // Base scale on iPhone X
    return fontSize * scale.clamp(0.8, 1.2); // Limit scaling
  }
}

/// Spacing extensions
extension SpacingExtension on BuildContext {
  /// Get spacing value (4, 8, 12, 16, 20, 24, 32, 40, 48, 64)
  double spacing(double multiplier) => 4 * multiplier;

  /// Common spacing values
  double get spacingXS => spacing(1); // 4
  double get spacingS => spacing(2); // 8
  double get spacingM => spacing(3); // 12
  double get spacingL => spacing(4); // 16
  double get spacingXL => spacing(5); // 20
  double get spacingXXL => spacing(6); // 24
  double get spacingXXXL => spacing(8); // 32
  double get spacingHuge => spacing(10); // 40
  double get spacingGiant => spacing(12); // 48
  double get spacingMassive => spacing(16); // 64
}

