class Todo implements Comparable<Todo> {
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

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed': completed,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Todo && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, title: $title, completed: $completed, createdAt: $createdAt)';
  }

  @override
  int get hashCode => id.hashCode;

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
  int compareTo(Todo other) {
    return createdAt.compareTo(other.createdAt);
  }

  Todo toggleCompleted() {
    return copyWith(completed: !completed);
  }
}
