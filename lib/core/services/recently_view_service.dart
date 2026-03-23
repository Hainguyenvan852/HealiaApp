import 'package:shared_preferences/shared_preferences.dart';

class RecentlyViewedService {
  static const String _key = 'recently_viewed_stores';
  static const int _maxItems = 20;

  static Future<void> addRecentlyViewed(String itemId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> recentIds = prefs.getStringList(_key) ?? [];

    recentIds.remove(itemId);

    recentIds.insert(0, itemId);

    if (recentIds.length > _maxItems) {
      recentIds = recentIds.sublist(0, _maxItems);
    }

    await prefs.setStringList(_key, recentIds);
  }

  static Future<List<String>> getRecentlyViewedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}