import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/entities/address_location.dart';

part 'route.freezed.dart';

@freezed
sealed class Route with _$Route {
  const factory Route({
    required List<AddressLocation> polyline, // Direction API's "direction" array
    required double timeTaken, // seconds
    required double totalDistance, // km
  }) = _Route;
}
