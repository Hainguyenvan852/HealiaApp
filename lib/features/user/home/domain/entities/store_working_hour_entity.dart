import 'package:flutter/material.dart';

class StoreWorkingHourEntity {
  int id, dayOfWeek, storeId;
  TimeOfDay startTime, endTime;
  bool isDayOff;

  StoreWorkingHourEntity({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isDayOff,
    required this.storeId,
  });
}
