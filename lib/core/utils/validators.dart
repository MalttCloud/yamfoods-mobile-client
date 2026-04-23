import '../errors/failure.dart';

class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim().toLowerCase());
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  
   static bool isValidEthiopianPhone(String phone) {
    // Accepts:
    // 9xxxxxxxx / 7xxxxxxxx (9 digits, starts with 9 or 7)
    // 09xxxxxxxx / 07xxxxxxxx (10 digits, starts with 09 or 07)
    final phoneRegex = RegExp(r'^0?[79]\d{8}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  
  static String formatEthiopianPhone(String phone) {
    String p = phone.trim();
    if (p.startsWith('0')) {
      return '251${p.substring(1)}';
    } else if (p.startsWith('9') || p.startsWith('7')) {
      return '251$p';
    }
    return p;
  }

  static bool isValidOtp(String otp) {
    final otpRegex = RegExp(r'^\d{4,6}$');
    return otpRegex.hasMatch(otp.trim());
  }

  static bool isValidPassword(String password) {
    if (password.length < 6) return false;
    // Basic complexity: at least one uppercase, number (expand as needed)
    // final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    // final hasNumber = RegExp(r'\d').hasMatch(password);
    return true;
    // return hasUpper && hasNumber;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    //check length mean 3
    if (value.length < 3) return 'Minimum 3 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value != original) return 'Passwords do not match';
    return null;
  }

  /// Validates latitude and longitude coordinates.
  ///
  /// Returns a [ValidationFailure] if coordinates are out of valid range,
  /// otherwise returns `null`.
  ///
  /// Valid ranges:
  /// - Latitude: -90 to 90
  /// - Longitude: -180 to 180
  static Failure? validateCoordinates(double lat, double lng) {
    if (lat < -90 || lat > 90) {
      return const Failure.validation(
        message: 'Latitude must be between -90 and 90',
      );
    }
    if (lng < -180 || lng > 180) {
      return const Failure.validation(
        message: 'Longitude must be between -180 and 180',
      );
    }
    return null;
  }

  /// Validates address field (required, 5–50 characters).
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'Address is required';
    final len = value.trim().length;
    if (len < 5) return 'Address must be at least 5 characters';
    if (len > 100) return 'Address must not exceed 100 characters';
    return null;
  }

  /// Validates receiver name field (optional).
  static String? validateReceiverName(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length > 30) {
        return 'Receiver name must not exceed 30 characters';
      }
    }
    return null;
  }

  /// Validates receiver phone field (optional).
  static String? validateReceiverPhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length > 20) {
        return 'Receiver phone must not exceed 20 characters';
      }
    }
    return null;
  }

  /// Validates note field (optional).
  ///
  /// Returns error message if validation fails, otherwise returns `null`.
  static String? validateNote(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length > 200) {
        return 'Note must not exceed 200 characters';
      }
    }
    return null;
  }
}
