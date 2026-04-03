import 'package:flutter/material.dart';
import 'package:healio_app/features/home/domain/entities/store_working_hour_entity.dart';

class StoreWorkingHourModel extends StoreWorkingHourEntity {
  StoreWorkingHourModel({
    required super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.isDayOff,
    required super.storeId,
  });

  factory StoreWorkingHourModel.fromJson(Map<String, dynamic> json) {
    final starts = json['start_time'].toString().split(':');
    final ends = json['end_time'].toString().split(':');

    return StoreWorkingHourModel(
      id: json['id'] as int,
      dayOfWeek: json['day_of_week'] as int,
      startTime: TimeOfDay(hour: int.parse(starts[0]), minute: int.parse(starts[1])),
      endTime: TimeOfDay(hour: int.parse(ends[0]), minute: int.parse(ends[1])),
      isDayOff: json['is_day_off'] as bool,
      storeId: json['store_id'] as int,
    );
  }
}
