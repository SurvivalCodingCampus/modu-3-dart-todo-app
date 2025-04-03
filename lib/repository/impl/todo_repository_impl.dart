import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:todo_app/data_source/local/todo_data_source.dart';
import 'package:collection/collection.dart';
import '../../model/todo.dart';
import '../local/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource todoDataSource;
  final String logFilePath = r'lib/data/log.txt';

  const TodoRepositoryImpl(this.todoDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    final jsonList = await todoDataSource.readTodos();
    return jsonList.map((e) => Todo.fromJson(e)).toList();
  }

  @override
  Future<void> addTodo(String title) async {
    final todos = await getTodos();
    final newId = todos.isEmpty ? 1 : todos.map((e) => e.id).reduce(max) + 1;

    final newTodo = Todo(
      userId: 1,
      id: newId,
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );
    todos.add(newTodo);
    await todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
    //로그 처리
    await writeLogTodo('할 일 추가 완료 - ID: $newId, 제목: $title');
  }

  @override
  Future<void> updateTodo(int id, String title) async {
    final todos = await getTodos();
    final index = todos.indexWhere((e) => e.id == id);
    final updateTitleTodo = todos[index].copyWith(title: title);
    todos[index] = updateTitleTodo;
    await todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
    await writeLogTodo('할 일 제목 수정 - ID: $id, 새로운 제목: $title');
  }

  @override
  Future<void> toggleTodo(int id) async {
    final todos = await getTodos();
    final index = todos.indexWhere((e) => e.id == id);

    if (todos[index].completed == true) {
      final updateTitleTodo = todos[index].copyWith(completed: false);
      todos[index] = updateTitleTodo;
      await writeLogTodo('할 일 완료 토글 - ID: $id, 상태: 미완료');
    } else {
      final updateTitleTodo = todos[index].copyWith(completed: true);
      todos[index] = updateTitleTodo;
      await writeLogTodo('할 일 완료 토글 - ID: $id, 상태: 완료됨');
    }

    await todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> deleteTodo(int id) async {
    final todos = await getTodos();
    todos.removeWhere((e) => e.id == id);

    await todoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());
    await writeLogTodo('할 일 삭제됨 - ID: $id');
  }

  @override
  Future<List<Todo>> getSortedDate(int choice) async {
    final todos = await getTodos();

    if (choice == 1) {
      final sortedTodos = todos.sorted(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      return sortedTodos;
    } else if (choice == 2) {
      final sortedTodos = todos.sorted(
        (a, b) => a.createdAt.compareTo(b.createdAt),
      );
      return sortedTodos;
    } else {
      return todos;
    }
  }

  @override
  Future<List<Todo>> getToggleTodo(int choice) async {
    final todos = await getTodos();

    if (choice == 1) {
      final completedTodos = todos.where((e) => e.completed == true).toList();
      return completedTodos;
    } else if (choice == 2) {
      final completedTodos = todos.where((e) => e.completed == false).toList();
      return completedTodos;
    } else {
      return todos;
    }
  }

  Future<List<int>> getTodosIdList() async {
    final todos = await getTodos();

    final todosIdList = todos.map((e) => e.id).toList();

    return todosIdList;
  }

  @override
  Future<void> writeLogTodo(String message) async {
    final File logFile = File(logFilePath);
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] $message \n';
    await logFile.writeAsString(logMessage, mode: FileMode.append);
  }
}
