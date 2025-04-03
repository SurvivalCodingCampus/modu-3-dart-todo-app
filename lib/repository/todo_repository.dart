import 'package:todo_app/enum/todo_condition.dart';
import 'package:todo_app/model/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> getTodos({
    TodoCondition condition,
  });
  Future<void> addTodo(String title);
  Future<void> updateTodo(int id, String newTitle);
  Future<bool> toggleTodo(int id);
  Future<void> deleteTodo(int id);
  Future<int> getLastIndex();
}
