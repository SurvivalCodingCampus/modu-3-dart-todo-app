import 'dart:math';

import 'package:collection/collection.dart';

import '../data_source/todo_data_source.dart';
import '../logs/logs.dart';
import '../model/todo.dart';
import 'todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _dataSource;

  TodoRepositoryImpl({required TodoDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<void> addTodo(String title) async {
    try {
      List<Todo> todoList = await getTodos();
      // print('todoList : $todoList');

      final newTodo = Todo(
        userId: 1,
        id: todoList.last.id + 1,
        title: title,
        completed: false,
        createdAt: DateTime.now(),
      );
      // print('newTodo : $newTodo');

      todoList.add(newTodo);

      await _dataSource.writeTodos(todoList.map((e) => e.toJson()).toList());
      writeLogs('할 일 추가됨 - ID: ${newTodo.id}, 제목: ${newTodo.title}');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    try {
      List<Todo> todoList = await getTodos();

      await _dataSource.writeTodos(
        todoList.where((e) => e.id != id).map((e) => e.toJson()).toList(),
      );
      writeLogs('할 일 삭제됨 - ID: $id');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final List<Map<String, dynamic>> todosJson =
          await _dataSource.readTodos();

      return todosJson
          .map((e) => Todo.fromJson(e))
          .toList()
          .sorted((a, b) => a.id.compareTo(b.id));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleTodo(int id) async {
    try {
      List<Todo> todoList = await getTodos();

      await _dataSource.writeTodos(
        todoList.map((e) {
          if (e.id == id) {
            writeLogs(
              '할 일 완료 토글 - ID: $id, 상태: ${e.completed == true ? '취소됨' : '완료됨'}',
            );
            return e.copyWith(completed: !e.completed).toJson();
          }
          return e.toJson();
        }).toList(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateTodo(int id, String newTitle) async {
    try {
      List<Todo> todoList = await getTodos();

      await _dataSource.writeTodos(
        todoList.map((e) {
          if (e.id == id) {
            return e.copyWith(title: newTitle).toJson();
          }
          return e.toJson();
        }).toList(),
      );
      writeLogs('할 일 제목 수정 - ID: $id, 새로운 제목: $newTitle');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Todo>> selectedWithCompletedTodo(bool completed) async {
    try {
      List<Todo> todoList = await getTodos();

      // writeLogs('Completed가 ${completed}인 할일 목록: ');
      writeLogs('Completed가 ${completed}인 할일 목록을 불러왔습니다.');
      return todoList.where((element) => element.completed == completed,).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Todo>> sortedWithCreatedAtTodo() async {
    try {
      List<Todo> todoList = await getTodos();

      
      writeLogs('생성일순으로 정렬했습니다.');
      return todoList.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      throw Exception(e);
    }
  }
}
