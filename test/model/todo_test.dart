import 'package:test/test.dart';
import 'package:todo_app/model/todo.dart';

void main() {
  final DateTime before = DateTime.parse('2025-04-02 13:00');
  final DateTime after = DateTime.parse('2025-04-02 14:00');

  final Map<String, dynamic> json = {
    'id': 1,
    'userId': 1,
    'title': "title",
    'completed': false,
    'createdAt': DateTime.now().toIso8601String(),
  };

  final List<Todo> todos = [
    Todo(id: 1, userId: 1, title: 'title', completed: false, createdAt: after),
    Todo(id: 1, userId: 2, title: 'diff', completed: true, createdAt: before),
  ];

  test('Todo.fromJson()을 통해 Map 형태를 인스턴스화 할 수 있어야한다.', () {
    final Todo todo = Todo.fromJson(json);
    expect(todo, isA<Todo>());
    expect(todo.id, 1);
  });

  test('Todo.toJson()을 통해 Map 형태로 반환해야한다.', () {
    Map<String, dynamic> todo = Todo.fromJson(json).toJson();

    expect(todo, isA<Map<String, dynamic>>());
    expect(todo['title'], 'title');
  });

  test('Todo 인스턴스의 id가 같으면 동등하다고 판단해야한다.', () {
    expect(todos.first, equals(todos.last));
  });

  test('Todo.copyWith()을 통해 복사한 객체의 id가 같을 경우 동등하다고 판단해야한다.', () {
    Todo origin = todos[0];
    Todo copied = origin.copyWith();

    expect(origin, equals(copied));
  });

  test('Todo.copyWith()을 통해 복사한 객체의 id가 다를 경우 다르다고 판단해야한다.', () {
    Todo origin = todos[0];
    Todo copied = origin.copyWith(id: 2);

    expect(origin, isNot(equals(copied)));
  });

  test('toggleCompleted() 사용 시 인스턴스의 completed만 토글된 인스턴스가 새롭게 반환되어야한다.', () {
    Todo todo = todos[0];

    expect(todo.completed, false);

    Todo copied = todo.toggleCompleted();
    expect(copied.completed, true);
  });

  test('List.sort() 사용 시 createdAt 기준 오름차순으로 정렬되어야한다.', () {
    List<Todo> expected = [...todos];
    List<Todo> sorted = todos..sort();

    expect(sorted.first, same(expected.last));
  });
}
