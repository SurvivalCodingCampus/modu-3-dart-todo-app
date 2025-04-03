import 'dart:convert';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  final DateTime createdAt;
  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  Todo copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Todo(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
      'createdAt': '${createdAt.toIso8601String().split('.').first}Z',
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      userId: map['userId'] as int? ?? 0,
      id: map['id'] as int? ?? 0,
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Todo(userId: $userId, id: $id, title: $title, completed: $completed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.userId == userId &&
        other.id == id &&
        other.title == title &&
        other.completed == completed &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        id.hashCode ^
        title.hashCode ^
        completed.hashCode ^
        createdAt.hashCode;
  }
}
