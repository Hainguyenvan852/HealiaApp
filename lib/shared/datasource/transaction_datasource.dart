import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionDatasource {
  final SupabaseClient _supabase;

  TransactionDatasource(this._supabase);

  // Hàm truy vấn lấy ra danh sách transaction theo store_id
  Future<List<TransactionModel>> getTransactionsByStoreId(int storeId) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select('*, clients(full_name)')
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response,
      );
      return data.map((json) => TransactionModel.fromJson2(json)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách transaction theo store_id: $e');
    }
  }

  // Hàm truy vấn lấy ra transaction theo appointment_id
  Future<TransactionModel?> getTransactionByAppointmentId(
    int appointmentId,
  ) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select('*, clients(full_name)')
          .eq('appointment_id', appointmentId)
          .maybeSingle();

      if (response == null) return null;

      return TransactionModel.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('Lỗi khi lấy transaction theo appointment_id: $e');
    }
  }

  // Hàm truy vấn lấy ra danh sách transaction theo customer_id
  Future<List<TransactionModel>> getTransactionsByCustomerId(
    String customerId,
  ) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select('*, profiles(full_name)')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response,
      );
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách transaction theo customer_id: $e');
    }
  }

  // Hàm thêm transaction mới
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await _supabase
          .from('transactions')
          .insert(transaction.toJson())
          .select()
          .single();

      return TransactionModel.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('Lỗi khi tạo transaction mới: $e');
    }
  }

  // Hàm cập nhật status của transaction
  Future<bool> updateTransactionStatus(int id, String status) async {
    try {
      await _supabase
          .from('transactions')
          .update({'payment_status': status})
          .eq('id', id);
      return true;
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái transaction: $e');
    }
  }

  // Hàm cập nhật thanh toán
  Future<bool> updateTransactionPayment(int id, String status, String method) async {
    try {
      await _supabase
          .from('transactions')
          .update({'payment_status': status, 'payment_method': method})
          .eq('id', id);
      return true;
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thanh toán transaction: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClientTransactionsWithService(
    int clientId,
    int storeId,
  ) async {
    try {
      final response = await _supabase
          .from('transactions')
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
          .eq('client_id', clientId)
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Lỗi khi lấy giao dịch: $e');
    }
  }
}
