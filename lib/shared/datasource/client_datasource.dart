import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/client_model.dart';

class ClientDatasource {
  final SupabaseClient _supabase;

  ClientDatasource(this._supabase);

  // Lấy danh sách client theo store_id
  Future<List<ClientModel>> getClientsByStoreId(int storeId) async {
    try {
      final response = await _supabase
          .from('clients')
          .select()
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response,
      );
      return data.map((json) => ClientModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách client: $e');
    }
  }

  Future<ClientModel?> getClientsByCustomerId(String userId) async {
    try {
      final response = await _supabase
          .from('clients')
          .select()
          .eq('profile_id', userId)
          .single();

      if (response.isEmpty) {
        return null;
      }
      return ClientModel.fromJson(response);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách client: $e');
    }
  }

  // Thêm client mới
  Future<ClientModel> createClient(ClientModel client) async {
    try {
      final response = await _supabase
          .from('clients')
          .insert(client.toJson())
          .select()
          .single();

      return ClientModel.fromJson(response);
    } catch (e) {
      throw Exception('Lỗi khi thêm client mới: $e');
    }
  }

  // Cập nhật thông tin client
  Future<ClientModel> updateClient(int id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('clients')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return ClientModel.fromJson(response);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật client: $e');
    }
  }

  // Xóa client (cập nhật is_active thành false)
  Future<bool> deleteClient(int id) async {
    try {
      final res = await _supabase
          .from('clients')
          .update({'is_active': false})
          .eq('id', id)
          .select();

      if (res.isEmpty) {
        throw Exception('RLS blocked the update or record not found');
      }

      return true;
    } catch (e) {
      throw Exception('Lỗi khi xóa client: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClientReviews(
    String? profileId,
    int storeId,
  ) async {
    if (profileId == null || profileId.isEmpty) return [];
    try {
      final response = await _supabase
          .from('reviews')
          .select('''
            *,
            appointments (
              appointment_services (
                services (
                  name
                )
              )
            )
          ''')
          .eq('customer_id', profileId)
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Lỗi khi lấy đánh giá của khách hàng: $e');
    }
  }
}
