import 'dart:math' as math;

/// Number extensions for formatting and conversions
extension NumberExtension on num {
  /// Format number with thousand separator
  String get formatted {
    if (this is int) {
      return toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format as currency
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final formattedValue = toStringAsFixed(decimals).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$symbol$formattedValue';
  }

  /// Format as percentage
  String toPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format file size (bytes to KB, MB, GB)
  String get fileSize {
    if (this < 1024) return '${toStringAsFixed(0)} B';
    if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(2)} KB';
    }
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Format duration (seconds to readable format)
  String get duration {
    if (this < 60) return '${toStringAsFixed(0)}s';
    if (this < 3600) {
      final minutes = (this / 60).floor();
      final seconds = (this % 60).floor();
      return '${minutes}m ${seconds}s';
    }
    final hours = (this / 3600).floor();
    final minutes = ((this % 3600) / 60).floor();
    return '${hours}h ${minutes}m';
  }

  /// Clamp number between min and max
  num clampBetween(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Check if number is between min and max (inclusive)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Convert to double safely
  double toDoubleSafe() {
    return toDouble();
  }

  /// Convert to int safely
  int toIntSafe() {
    return toInt();
  }
}

/// Double extensions
extension DoubleExtension on double {
  /// Round to specified decimal places
  double roundTo(int decimals) {
    final factor = math.pow(10, decimals);
    return (this * factor).round() / factor;
  }

  /// Check if double is approximately equal (within epsilon)
  bool isApproximatelyEqual(double other, {double epsilon = 0.0001}) {
    return (this - other).abs() < epsilon;
  }
}

/// Int extensions
extension IntExtension on int {
  /// Format with leading zeros
  String padLeft(int width, [String padding = '0']) {
    return toString().padLeft(width, padding);
  }

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Convert to ordinal string (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this % 100 >= 11 && this % 100 <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}
