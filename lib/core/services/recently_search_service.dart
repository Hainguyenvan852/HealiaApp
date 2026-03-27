import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlySearchService {
  static const String _keySearch = 'recently_search';
  static const String _keyLocationSearch = 'recently_location_search';
  static const int _maxItems = 5;

  static Future<void> addRecentLocation(String name, String address, double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();

    final itemJson = jsonEncode({
      'name' : name,
      'address' : address,
      'lat' : lat,
      'lng' : lng
    });

    List<String> recentIds = prefs.getStringList(_keyLocationSearch) ?? [];

    recentIds.remove(itemJson);

    recentIds.insert(0, itemJson);

    if (recentIds.length > _maxItems) {
      recentIds = recentIds.sublist(0, _maxItems);
    }

    await prefs.setStringList(_keyLocationSearch, recentIds);
  }

  static Future<List<Map<String, dynamic>>> getRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getStringList(_keyLocationSearch) ?? [];

    return result.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> clearRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey(_keyLocationSearch)) {
       prefs.remove(_keyLocationSearch);
    };
  }

  static Future<void> addRecentSearch(String address, double? lat, double? lng, DateTime? date, TimeOfDay? startTime, TimeOfDay? endTime, String category, String dateText, String timeText) async {
    final prefs = await SharedPreferences.getInstance();

    final itemJson = jsonEncode({
      'category' : category,
      'dateText' : dateText,
      'timeText' : timeText,
      'startTime' : startTime != null ? '${startTime.hour.toString()}:${startTime.minute.toString()}' : null,
      'endTime' : endTime != null ? '${endTime.hour.toString()}:${endTime.minute.toString()}' : null,
      'date' : date,
      'lat' : lat,
      'lng' : lng,
      'address' : address,
    });

    List<String> recentIds = prefs.getStringList(_keySearch) ?? [];

    recentIds.remove(itemJson);

    recentIds.insert(0, itemJson);

    if (recentIds.length > _maxItems) {
      recentIds = recentIds.sublist(0, _maxItems);
    }

    await prefs.setStringList(_keySearch, recentIds);
  }

  static Future<List<Map<String, dynamic>>> getRecentSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getStringList(_keySearch) ?? [];

    return result.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> clearRecentSearch() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey(_keySearch)) {
      prefs.remove(_keySearch);
    };
  }
}