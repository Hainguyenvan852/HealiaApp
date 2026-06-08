import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationDatasource {
  final SupabaseClient _supabaseClient;

  NotificationDatasource(this._supabaseClient);

  Future<List<NotificationModel>> getNotificationsByUserId(
    String userId,
  ) async {
    final response = await _supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _supabaseClient
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((events) {
          final notifications = events
              .map((e) => NotificationModel.fromJson(e))
              .toList();
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return notifications;
        });
  }
}
