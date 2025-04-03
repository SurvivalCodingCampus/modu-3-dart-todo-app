import 'package:todo_app/data_source/todo_data_source.dart';

class MockTodoDataSource implements TodoDataSource {
  List<Map<String, dynamic>> data = [
    {
      'userId': 1,
      'id': 1,
      'title': 'test',
      'completed': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'userId': 1,
      'id': 2,
      'title': 'test2',
      'completed': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'userId': 2,
      'id': 3,
      'title': 'test3',
      'completed': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> readTodos() async {
    return data;
  }

  @override
  Future<void> writeTodos(List<Map<String, dynamic>> todos) async {
    data = todos;
  }
}
