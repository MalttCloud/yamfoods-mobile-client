// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/mappers/address_location_mapper.dart';
import '../../../../shared/models/address_location_model.dart';
import '../../domain/entities/route.dart';


part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
sealed class RouteModel with _$RouteModel {
  const factory RouteModel({ 
    required double timetaken,
    required double totalDistance,
    required List<List<double>> direction,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}

extension RouteModelMapper on RouteModel {
  Route toDomain() => Route(
    polyline: direction
        .map(
          (coords) =>
              AddressLocationModel(latitude: coords[0], longitude: coords[1]).toDomain(),
        )
        .toList(),
    timeTaken: timetaken,
    totalDistance: totalDistance / 1000, // Convert meters to km
  );
}
