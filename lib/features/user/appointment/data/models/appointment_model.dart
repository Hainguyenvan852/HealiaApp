import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentModel {
  int id;
  String status;
  DateTime startTime;
  DateTime endTime;
  String? notes;
  double totalPrice;
  DateTime createdAt;
  int storeId;
  String storeName;
  String storeAddress;
  String? customerId;
  String customerName;
  String? professionalName;
  int? professionalId;
  int clientId;
  List<ServiceModel> services;
  String? cancelReason;

  AppointmentModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.storeAddress,
    this.notes,
    required this.storeName,
    required this.totalPrice,
    required this.createdAt,
    required this.storeId,
    this.customerId,
    this.professionalId,
    required this.services,
    this.professionalName,
    required this.customerName,
    required this.clientId,
    this.cancelReason,
  });

  AppointmentModel copyWith({
    int? id,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    String? notes,
    String? storeName,
    double? totalPrice,
    DateTime? createdAt,
    int? storeId,
    String? customerId,
    String? storeAddress,
    int? memberId,
    String? customerName,
    String? memberName,
    String? priceType,
    List<ServiceModel>? services,
    int? clientId,
    String? cancelReason,
  }) => AppointmentModel(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    status: status ?? this.status,
    notes: notes,
    totalPrice: totalPrice ?? this.totalPrice,
    createdAt: createdAt ?? this.createdAt,
    storeId: storeId ?? this.storeId,
    customerId: customerId ?? this.customerId,
    professionalId: memberId ?? this.professionalId,
    services: services ?? this.services,
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress ?? this.storeAddress,
    professionalName: memberName ?? this.professionalName,
    customerName: customerName ?? this.customerName,
    clientId: clientId ?? this.clientId,
    cancelReason: cancelReason ?? this.cancelReason,
  );

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final startTs = json['start_time'] as String;
    final endTs = json['end_time'] as String;
    final createdAtTs = json['created_at'] as String;
    final serviceJson = json['services'] as List<dynamic>;

    final serviceList = serviceJson
        .map((e) => ServiceModel.fromJson(e))
        .toList();

    return AppointmentModel(
      id: json['id'] as int,
      startTime: DateTime.parse(startTs).toLocal(),
      endTime: DateTime.parse(endTs).toLocal(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(createdAtTs).toLocal(),
      customerId: json['customer_id'] as String?,
      storeId: json['store_id'] as int,
      professionalId: json['member_id'] as int?,
      services: serviceList,
      storeName: json['store_name'] as String,
      storeAddress: json['store_address'] as String,
      professionalName: json['member_name'] as String?,
      customerName: json['customer_name'] as String? ?? '',
      clientId: json['client_id'] as int,
      cancelReason: json['cancel_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'start_time': startTime.toUtc().toIso8601String(),
    'end_time': endTime.toUtc().toIso8601String(),
    'status': status,
    'notes': notes,
    'total_price': totalPrice,
    'created_at': createdAt.toUtc().toIso8601String(),
    'customer_id': customerId,
    'store_id': storeId,
    'member_id': professionalId,
    'client_id': clientId,
    'cancel_reason': cancelReason,
  };
}

class StoreAppointment extends Appointment {
  StoreAppointment({
    required this.model,
    required super.startTime,
    required super.endTime,
    super.color,
    super.subject,
    super.id,
    super.resourceIds,
  });

  final AppointmentModel model;
}
