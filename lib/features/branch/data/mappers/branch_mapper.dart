import '../../domain/entities/branch.dart';
import '../models/branch_model.dart';
import 'working_day_mapper.dart';

extension BranchModelMapper on BranchModel {
  /// Converts [BranchModel] to [Branch] domain entity.
  ///
  /// Parses the location string to a structured record type.
  /// Location format can be:
  /// - "{lat: 9.027596658385972, lng: 38.72061392133383}" (with labels and braces)
  /// - "{9.027596658385972, 38.72061392133383}" (with braces only)
  /// - "9.027596658385972, 38.72061392133383" (plain format)
  Branch toDomain() {
    final location = _parseLocation(this.location);

    return Branch(
      id: id,
      name: name,
      location: location,
      address: address,
      isActive: isActive == 1,
      contactPhone: contactPhone,
      openingHour: openingHour,
      closingHour: closingHour,
      activeWorkingDays: activeWorkingDays
          .map((day) => day.toDomain())
          .toList(),
      launchDate: launchDate,
      createdDate: createdDate,
      lastUpdateDate: lastUpdateDate,
      createdBy: createdBy,
    );
  }

  /// Parses location string to a record type with lat and lng.
  ///
  /// Handles multiple formats:
  /// 1. "{lat: 9.027596658385972, lng: 38.72061392133383}" - with labels and braces
  /// 2. "{9.027596658385972, 38.72061392133383}" - with braces only
  /// 3. "9.027596658385972, 38.72061392133383" - plain format
  ///
  /// Validates that latitude is between -90 and 90, and longitude is between -180 and 180.
  ///
  /// Throws [FormatException] with user-friendly message if parsing fails.
  ({double lat, double lng}) _parseLocation(String locationString) {
    try {
      // Use regex to extract all decimal numbers from the string
      // Pattern matches: optional minus sign, one or more digits, optional decimal point and one or more digits
      // This ensures we match complete numbers (e.g., "9.5" or "9", but not incomplete "9.")
      final numberPattern = RegExp(r'-?\d+(?:\.\d+)?');
      final matches = numberPattern.allMatches(locationString);

      if (matches.length < 2) {
        throw FormatException(
          'Unable to read branch location. Please contact support if this issue persists.',
        );
      }

      // Extract the first two numbers as lat and lng
      final latString = matches.elementAt(0).group(0)!;
      final lngString = matches.elementAt(1).group(0)!;

      double lat;
      double lng;

      try {
        lat = double.parse(latString);
        lng = double.parse(lngString);
      } catch (e) {
        throw FormatException(
          'Unable to read branch location. Please contact support if this issue persists.',
        );
      }

      // Validate latitude range (-90 to 90)
      if (lat < -90 || lat > 90) {
        throw FormatException(
          'Branch location appears to be invalid. Please contact support.',
        );
      }

      // Validate longitude range (-180 to 180)
      if (lng < -180 || lng > 180) {
        throw FormatException(
          'Branch location appears to be invalid. Please contact support.',
        );
      }

      return (lat: lat, lng: lng);
    } catch (e) {
      // Catch all errors and provide a user-friendly message
      // Log the actual error for debugging (but don't expose to user)
      if (e is FormatException) {
        // If it's already a FormatException with user-friendly message, re-throw it
        rethrow;
      }
      // For any other unexpected errors, provide generic user-friendly message
      throw FormatException(
        'Unable to process branch location. Please try again or contact support if the problem continues.',
      );
    }
  }
}
