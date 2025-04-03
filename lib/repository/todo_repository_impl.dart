import 'package:todo_app/data_source/todo_data_source.dart';
import 'package:todo_app/enum/todo_condition.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:collection/collection.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _todoDataSource;

  TodoRepositoryImpl({required TodoDataSource todoDataSource})
    : _todoDataSource = todoDataSource;

  @override
  Future<void> addTodo(String title) async {
    final lastId = await getLastIndex();
    final newTodo = Todo(
      userId: 1,
      id: lastId + 1,
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );

    final todos = await getTodos();
    todos.add(newTodo);
    await _todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> deleteTodo(int id) async {
    final todos = await getTodos();
    todos.removeWhere((e) => e.id == id);
    await _todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
  }

  @override
  Future<int> getLastIndex() async {
    final todos = await getTodos();
    return todos.last.id;
  }

  @override
  Future<List<Todo>> getTodos({
    TodoCondition condition = TodoCondition.base,
  }) async {
    final resp = await _todoDataSource.readTodos();
    final todos = resp.map((e) => Todo.fromJson(e)).toList();

    switch (condition) {
      // 날짜 순서로 오름차순
      case TodoCondition.isAscending:
        return todos.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
      // 날짜 순서로 내림차순
      case TodoCondition.isDescending:
        return todos.sorted((a, b) => b.createdAt.compareTo(a.createdAt));
      // 완료된 것만
      case TodoCondition.isCompleted:
        return todos.where((e) => e.completed).toList();
      // 미완료된 것만
      case TodoCondition.isNotCompleted:
        return todos.where((e) => !e.completed).toList();
      case TodoCondition.base:
        return todos;
    }
  }

  @override
  Future<bool> toggleTodo(int id) async {
    final resp = await getTodos();
    final todos =
        resp
            .map((e) => e.id == id ? e.copyWith(completed: !e.completed) : e)
            .toList();
    await _todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
    return todos.where((e) => e.id == id).first.completed;
  }

  @override
  Future<void> updateTodo(int id, String newTitle) async {
    final resp = await getTodos();
    final todos =
        resp.map((e) => e.id == id ? e.copyWith(title: newTitle) : e).toList();
    await _todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
  }
}
