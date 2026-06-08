import 'package:flutter/material.dart';

class SearchFilterState {
  String category;
  String locationName;
  String? address;
  double? lat;
  double? lng;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String timeText;
  String dateText;
  DateTime? date;

  SearchFilterState({
    this.category = 'All treatments',
    this.locationName = 'Current location',
    this.timeText = 'Anytime',
    this.dateText = 'Any date',
    this.date,
    this.startTime,
    this.endTime,
    this.lat,
    this.lng,
    this.address
  });

  SearchFilterState copyWith({String? category, String? location, double? lat, double? lng, TimeOfDay? startTime, TimeOfDay? endTime, String? timeText, String? dateText, DateTime? date, String? address})
  => SearchFilterState(
      category: category ?? this.category,
      locationName: location ?? this.locationName,
      timeText: timeText ?? this.timeText,
      dateText: dateText ?? this.dateText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      address: address ?? this.address
  );

  SearchFilterState clearDateTime()
  => SearchFilterState(
      category: this.category,
      locationName: this.locationName,
      timeText: 'Anytime',
      dateText: 'Any date',
      lat: this.lat,
      lng: this.lng,
      startTime: null,
      endTime: null,
      date: null
  );

  SearchFilterState update({required String category, required String location, double? lat, double? lng, TimeOfDay? startTime, TimeOfDay? endTime, required String timeText, required String dateText, DateTime? date, String? address})
  => SearchFilterState(
      category: category,
      locationName: location,
      timeText: timeText,
      dateText: dateText,
      lat: lat,
      lng: lng,
      startTime: startTime,
      endTime: endTime,
      date: date,
      address: address
  );
}