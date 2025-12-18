class Validators {
  // Email validation
  static String? email(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Email is required' : null;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Phone number validation (generic)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Pakistani phone number validation
  // Supports formats: 03XX-XXXXXXX, +923XX-XXXXXXX, 923XX-XXXXXXX
  static String? pakistaniPhoneNumber(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }

    // Remove spaces, dashes, and parentheses
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');

    // Extract only digits
    final digitsOnly = cleaned.replaceAll(RegExp(r'[^\d]'), '');

    // Pakistani phone number must be:
    // - 11 digits starting with 03 (e.g., 03XX-XXXXXXX)
    // - 13 digits starting with 92 (e.g., 923XX-XXXXXXX or +923XX-XXXXXXX)
    if (digitsOnly.length == 11) {
      // Must start with 03
      if (!digitsOnly.startsWith('03')) {
        return 'Pakistani mobile number must start with 03 (e.g., 03XX-XXXXXXX)';
      }
      // Validate it's a valid mobile network (03XX where XX is 00-99)
      final networkCode = digitsOnly.substring(2, 4);
      if (int.tryParse(networkCode) == null) {
        return 'Please enter a valid mobile network code';
      }
    } else if (digitsOnly.length == 13) {
      // Must start with 92 (country code)
      if (!digitsOnly.startsWith('92')) {
        return 'Phone number with country code must start with 92';
      }
      // After country code, must have 03
      if (!digitsOnly.substring(2, 4).startsWith('3')) {
        return 'Pakistani mobile number must start with 03 after country code';
      }
    } else {
      return 'Phone number must be 11 digits (03XX-XXXXXXX) or 13 digits with country code (+923XX-XXXXXXX)';
    }

    return null;
  }

  // Name validation (allows letters, spaces, hyphens, apostrophes)
  static String? name(
    String? value, {
    bool isRequired = true,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? '${fieldName ?? 'Name'} is required' : null;
    }

    // Trim whitespace
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return isRequired ? '${fieldName ?? 'Name'} is required' : null;
    }

    // Name should contain only letters, spaces, hyphens, apostrophes, and dots
    final nameRegex = RegExp(r"^[a-zA-Z\s'\-\.]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return '${fieldName ?? 'Name'} can only contain letters, spaces, hyphens, and apostrophes';
    }

    // Name should be at least 2 characters
    if (trimmed.length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters';
    }

    // Name should not start or end with special characters
    if (trimmed.startsWith('-') ||
        trimmed.startsWith("'") ||
        trimmed.startsWith('.') ||
        trimmed.endsWith('-') ||
        trimmed.endsWith("'") ||
        trimmed.endsWith('.')) {
      return '${fieldName ?? 'Name'} cannot start or end with special characters';
    }

    // Name should not have consecutive special characters
    if (RegExp(r"['\-\.]{2,}").hasMatch(trimmed)) {
      return '${fieldName ?? 'Name'} cannot have consecutive special characters';
    }

    return null;
  }

  // Text field validation (general purpose)
  static String? text(
    String? value, {
    bool isRequired = true,
    String? fieldName,
    int? minLength,
    int? maxLength,
    bool allowNumbers = true,
    bool allowSpecialChars = true,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? '${fieldName ?? 'This field'} is required' : null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty && isRequired) {
      return '${fieldName ?? 'This field'} is required';
    }

    // Check minimum length
    if (minLength != null && trimmed.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }

    // Check maximum length
    if (maxLength != null && trimmed.length > maxLength) {
      return '${fieldName ?? 'This field'} must be at most $maxLength characters';
    }

    // Validate characters based on flags
    if (!allowNumbers && RegExp(r'\d').hasMatch(trimmed)) {
      return '${fieldName ?? 'This field'} cannot contain numbers';
    }

    if (!allowSpecialChars &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmed)) {
      return '${fieldName ?? 'This field'} cannot contain special characters';
    }

    return null;
  }

  // PKR (Pakistani Rupee) amount validation
  static String? pkrAmount(
    String? value, {
    bool isRequired = true,
    double? minAmount,
    double? maxAmount,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Amount is required' : null;
    }

    // Remove currency symbols, spaces, and commas
    final cleaned = value
        .replaceAll(RegExp(r'[Rs\.\s,]'), '')
        .replaceAll('PKR', '')
        .replaceAll('Rs', '')
        .trim();

    if (cleaned.isEmpty) {
      return isRequired ? 'Amount is required' : null;
    }

    // Validate numeric format (allows decimal)
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(cleaned)) {
      return 'Please enter a valid amount (e.g., 1000 or 1000.50)';
    }

    // Parse the amount
    final amount = double.tryParse(cleaned);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    // Check minimum amount
    if (minAmount != null && amount < minAmount) {
      return 'Amount must be at least Rs. ${minAmount.toStringAsFixed(2)}';
    }

    // Check maximum amount
    if (maxAmount != null && amount > maxAmount) {
      return 'Amount must not exceed Rs. ${maxAmount.toStringAsFixed(2)}';
    }

    // Amount should be positive
    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  // OTP validation
  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != length) {
      return 'OTP must be $length digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }

  // Min length validation
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  // Max length validation
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be at most $maxLength characters';
    }
    return null;
  }

  // Combine multiple validators
  static String? combine(
    List<String? Function(String?)> validators,
    String? value,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
