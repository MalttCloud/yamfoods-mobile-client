import '../../domain/entities/working_day.dart';
import '../models/working_day_model.dart';

extension WorkingDayModelMapper on WorkingDayModel {
  WorkingDay toDomain() => WorkingDay(label: label, value: value);
}
