import 'package:intl/intl.dart';

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
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
      'createdAt': createdAt.toString(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return '[${completed ? '✓' : ' '}] id:$id  $title (${DateFormat('yyyy-MM-dd hh:mm').format(createdAt)})';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
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
