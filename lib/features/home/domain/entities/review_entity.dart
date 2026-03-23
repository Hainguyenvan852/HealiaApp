class ReviewEntity {
  int id;
  String customerId;
  String staffId;
  String appointmentId;
  double rating;
  String? comment;
  DateTime createdAt;

  ReviewEntity({ required this.id, required this.customerId, required this.staffId, required this.appointmentId, required this.rating, required this.comment, required this.createdAt});
}