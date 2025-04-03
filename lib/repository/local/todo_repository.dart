import '../../model/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> getTodos();

  Future<void> addTodo(String title);

  Future<void> updateTodo(int id, String title);

  Future<List<Todo>> getToggleTodo(int id);

  Future<void> deleteTodo(int id);

  Future<List<Todo>> getSortedDate(int flag);

  Future<void> toggleTodo(int id);

  Future<void> writeLogTodo(String message);
}
