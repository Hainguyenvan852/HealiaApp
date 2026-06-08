class TransactionModel {
  final int id;
  final int appointmentId;
  final String? customerId;
  final int storeId;
  final double amount;
  final String paymentMethod; // at_store, online
  final String paymentStatus; // pending, paid, failed
  final DateTime createdAt;
  final String? customerName;
  final int clientId;

  TransactionModel({
    required this.id,
    required this.appointmentId,
    this.customerId,
    required this.storeId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.customerName,
    required this.clientId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Parse customer_name from joined profiles table
    String? cName;
    if (json['profiles'] != null && json['profiles']['full_name'] != null) {
      cName = json['profiles']['full_name'];
    }

    return TransactionModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      customerId: json['customer_id'] as String?,
      storeId: json['store_id'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      customerName: cName,
      clientId: json['client_id'],
    );
  }

  factory TransactionModel.fromJson2(Map<String, dynamic> json) {
    // Parse customer_name from joined clients table
    String? cName;
    if (json['clients'] != null && json['clients']['full_name'] != null) {
      cName = json['clients']['full_name'];
    }

    return TransactionModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      customerId: json['customer_id'] as String?,
      storeId: json['store_id'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      customerName: cName,
      clientId: json['client_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'customer_id': customerId,
      'store_id': storeId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'client_id': clientId,
    };
  }
}
