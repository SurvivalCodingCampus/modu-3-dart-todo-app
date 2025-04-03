import 'dart:convert';
import 'dart:io';

import 'package:todo_app/data_source/local/todo_data_source.dart';

import '../../model/todo.dart';

class TodoDataSourceImpl implements TodoDataSource {
  final String filePath;
  final String backUpFilePath;

  TodoDataSourceImpl({required this.filePath, required this.backUpFilePath});

  @override
  Future<List<Map<String, dynamic>>> readTodos() async {
    final File file = File(filePath);
    final backUpFile = File(backUpFilePath);

    String data = await file.readAsString();

    if (data.trim().isEmpty) {
      File copyFile = await backUpFile.copy(filePath);
      data = await copyFile.readAsString();
    }



    final List<dynamic> dataList = jsonDecode(data);

    return List<Map<String, dynamic>>.from(dataList);
  }

  @override
  Future<void> writeTodos(List<Map<String, dynamic>> todos) async {
    final File file = File(filePath);
    final jsonString = jsonEncode(todos);
    await file.writeAsString(jsonString);
  }
}
