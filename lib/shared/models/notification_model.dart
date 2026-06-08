class NotificationModel {
  final int id;
  final DateTime createdAt;
  final String title;
  final String content;
  final String type;
  final String userId;

  NotificationModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.type,
    required this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      content: json['content'],
      type: json['type'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'content': content,
      'type': type,
      'user_id': userId,
    };
  }
}
