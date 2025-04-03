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

  @override
  String toString() {
    return 'Todo{userId: $userId, id: $id, title: $title, completed: $completed, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          id == other.id &&
          title == other.title &&
          completed == other.completed &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      id.hashCode ^
      title.hashCode ^
      completed.hashCode ^
      createdAt.hashCode;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'id': id,
    'title': title,
    'completed': completed,
    'createdAt': createdAt.toIso8601String(),
  };
}
