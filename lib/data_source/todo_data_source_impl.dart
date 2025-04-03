import 'dart:convert';
import 'dart:io';

import 'package:todo_app/data_source/todo_data_source.dart';

class TodoDataSourceImpl implements TodoDataSource {
  final filePath = '${Directory.current.path}/lib/json_data/todo_data.json';

  @override
  Future<List<Map<String, dynamic>>> readTodo() async {
    try {
      final File jsonFile = File(filePath);

      final String jsonFromFile = await jsonFile.readAsString();

      final List jsonData = jsonDecode(jsonFromFile);

      return jsonData.cast<Map<String, dynamic>>();
    } on FileSystemException {
      throw FormatException('JSON 파싱오류');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> writeTodo(List<Map<String, dynamic>> todos) async {
    try {
      final File jsonFile = File(filePath);
      await jsonFile.writeAsString(jsonEncode(todos));
    } on FileSystemException {
      throw FormatException('JSON 파싱오류');
    } catch (e) {
      rethrow;
    }
  }
}
