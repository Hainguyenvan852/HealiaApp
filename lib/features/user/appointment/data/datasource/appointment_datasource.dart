import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentDatasource {
  final SupabaseClient _supabase;

  AppointmentDatasource(this._supabase);

  Future<List<AppointmentModel>> fetchCustomerAppointments(
    String userId,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_customer_appointments',
        params: {'p_customer_id': userId},
      );

      final appointments = List<Map<String, dynamic>>.from(response);

      return appointments
          .map((store) => AppointmentModel.fromJson(store))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<AppointmentModel>> fetchClientAppointments(
    int clientId,
    int storeId,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_client_appointments',
        params: {'p_client_id': clientId, 'p_store_id': storeId},
      );

      final appointments = List<Map<String, dynamic>>.from(response);

      return appointments
          .map((store) => AppointmentModel.fromJson(store))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<AppointmentModel>> fetchAppointmentsByDay(
    String userId,
    DateTime date,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_customer_appointments_by_date',
        params: {'p_customer_id': userId, 'date_by': date.toIso8601String()},
      );

      final appointments = List<Map<String, dynamic>>.from(response);

      return appointments
          .map((store) => AppointmentModel.fromJson(store))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int?> createNewAppointment(AppointmentModel newApm) async {
    try {
      final response = await _supabase
          .from('appointments')
          .insert(newApm.toJson())
          .select('id')
          .single();
      int ampId = response['id'];

      await Future.wait(
        newApm.services.map(
          (e) => _supabase.from('appointment_services').insert({
            'appointment_id': ampId,
            'service_id': e.id,
          }),
        ),
      );

      return ampId;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ReviewModel?> getReviewByApm(int apmId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('appointment_id', apmId);
      if (response.isEmpty) {
        return null;
      } else {
        return ReviewModel.fromJson(response[0]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> addReview(ReviewModel newReview) async {
    try {
      await _supabase.from('reviews').insert(newReview.toJson());

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> updateAppointmentStatus(int apmId, String status) async {
    try {
      await _supabase
          .from('appointments')
          .update({'status': status})
          .eq('id', apmId);

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> cancelAppointment(int apmId) async {
    try {
      await _supabase
          .from('appointments')
          .update({'status': 'cancelled'})
          .eq('id', apmId);

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> requestCancelAppointment(int apmId, String reason) async {
    try {
      await _supabase
          .from('appointments')
          .update({
             'status': 'cancel_pending',
             'cancel_reason': reason
          })
          .eq('id', apmId);

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> updateAppointmentTimeAndNotes(
    int apmId,
    DateTime startTime,
    DateTime endTime,
    String? notes,
  ) async {
    try {
      final updates = {
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
      };
      if (notes != null) {
        updates['notes'] = notes;
      }
      
      await _supabase
          .from('appointments')
          .update(updates)
          .eq('id', apmId);

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<AppointmentModel>> fetchStoreAppointments(int storeId) async {
    try {
      final response = await _supabase.rpc(
        'get_store_appointments',
        params: {'p_store_id': storeId},
      );

      final appointments = List<Map<String, dynamic>>.from(response);

      return appointments
          .map((store) => AppointmentModel.fromJson(store))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
