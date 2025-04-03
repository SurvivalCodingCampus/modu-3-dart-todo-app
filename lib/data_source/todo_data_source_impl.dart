import 'dart:convert';
import 'dart:io';

import 'todo_data_source.dart';

class TodoDataSourceImpl implements TodoDataSource {
  // final String path = 'lib/data/todos.json';
  final String path;

  TodoDataSourceImpl({required this.path});

  @override
  Future<List<Map<String, dynamic>>> readTodos() async {
    String? jsonString = await File(path).readAsString();

    if (jsonString == '') {
      jsonString = await File('lib/data/backup.dat').readAsString();
    }

    final List jsonList = jsonDecode(jsonString);
    final List<Map<String, dynamic>> todos = List<Map<String, dynamic>>.from(
      jsonList,
    );
    return todos;
  }

  @override
  Future<void> writeTodos(List<Map<String, dynamic>> todos) async {
    String json = jsonEncode(todos);
    await File(path).writeAsString(json);
  }
}
