import 'package:supabase_flutter/supabase_flutter.dart';

class ReportMetrics {
  final double totalRevenue;
  final int totalAppointments;

  ReportMetrics({
    required this.totalRevenue,
    required this.totalAppointments,
  });
}

class ReportChartData {
  final DateTime date;
  final double transactions;
  final int appointments;

  ReportChartData({
    required this.date,
    required this.transactions,
    required this.appointments,
  });
}

class ReportDatasource {
  final SupabaseClient _supabase;

  ReportDatasource(this._supabase);

  Future<int?> getManagerStoreId(String userId) async {
    final response = await _supabase
        .from('stores')
        .select('id')
        .eq('manager_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return response['id'] as int;
  }

  Future<ReportMetrics> getReportMetrics(int storeId) async {
    // Total Revenue (transactions table)
    final txResponse = await _supabase
        .from('transactions')
        .select('amount')
        .eq('store_id', storeId);

    double totalRevenue = 0;
    for (var tx in txResponse) {
      if (tx['amount'] != null) {
        totalRevenue += (tx['amount'] as num).toDouble();
      }
    }

    // Total Appointments
    final aptResponse = await _supabase
        .from('appointments')
        .select('id')
        .eq('store_id', storeId);

    return ReportMetrics(
      totalRevenue: totalRevenue,
      totalAppointments: aptResponse.length
    );
  }

  Future<List<ReportChartData>> getChartData(int storeId) async {
    final DateTime now = DateTime.now();
    final DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Fetch recent appointments
    final apts = await _supabase
        .from('appointments')
        .select('start_time')
        .eq('store_id', storeId)
        .gte('start_time', sevenDaysAgo.toIso8601String());

    // Fetch recent transactions
    final txs = await _supabase
        .from('transactions')
        .select('created_at, amount')
        .eq('store_id', storeId)
        .gte('created_at', sevenDaysAgo.toIso8601String());

    Map<String, ReportChartData> aggregated = {};

    // Initialize last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      aggregated[dateStr] = ReportChartData(
        date: DateTime(date.year, date.month, date.day),
        transactions: 0,
        appointments: 0,
      );
    }

    // Aggregate appointments
    for (var apt in apts) {
      if (apt['start_time'] != null) {
        final date = DateTime.parse(apt['start_time']).toLocal();
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (aggregated.containsKey(dateStr)) {
          final current = aggregated[dateStr]!;
          aggregated[dateStr] = ReportChartData(
            date: current.date,
            transactions: current.transactions,
            appointments: current.appointments + 1,
          );
        }
      }
    }

    // Aggregate transactions
    for (var tx in txs) {
      if (tx['created_at'] != null && tx['amount'] != null) {
        final date = DateTime.parse(tx['created_at']).toLocal();
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (aggregated.containsKey(dateStr)) {
          final current = aggregated[dateStr]!;
          aggregated[dateStr] = ReportChartData(
            date: current.date,
            transactions:
                current.transactions + (tx['amount'] as num).toDouble(),
            appointments: current.appointments,
          );
        }
      }
    }

    final sortedKeys = aggregated.keys.toList()..sort();
    return sortedKeys.map((k) => aggregated[k]!).toList();
  }

  Future<List<Map<String, dynamic>>> getUpcomingAppointments(
    int storeId, {
    bool onlyToday = false,
  }) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    var query = _supabase
        .from('appointments')
        .select('''
          id,
          start_time,
          end_time,
          total_price,
          status,
          clients:client_id(full_name),
          appointment_services(services(name))
        ''')
        .eq('store_id', storeId);

    if (onlyToday) {
      query = query
          .gte('start_time', todayStart.toUtc().toIso8601String())
          .lt('start_time', todayEnd.toUtc().toIso8601String());
    } else {
      query = query.gte('start_time', now.toUtc().toIso8601String());
    }

    final response = await query.order('start_time', ascending: true).limit(5);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPastAppointments(int storeId, {int days = 7}) async {
    final now = DateTime.now();
    final pastDate = now.subtract(Duration(days: days));

    var query = _supabase
        .from('appointments')
        .select('''
          id,
          start_time,
          end_time,
          total_price,
          status,
          clients:client_id(full_name),
          appointment_services(services(name))
        ''')
        .eq('store_id', storeId)
        .gte('start_time', pastDate.toUtc().toIso8601String())
        .lt('start_time', now.toUtc().toIso8601String());

    final response = await query.order('start_time', ascending: false).limit(10);
    return List<Map<String, dynamic>>.from(response);
  }
}
