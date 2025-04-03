import 'dart:convert';
import 'dart:io';

import 'package:todo_app/data_source/todo_data_source.dart';

class MockTodoDataSourceImpl implements TodoDataSource {
  final String _path;

  String backUpPath = 'data/backup.dat';

  MockTodoDataSourceImpl({String path = 'data/todos2.json'}) : _path = path;

  @override
  Future<List<Map<String, dynamic>>> readTodos() async {
    File file = File(_path);
    String fileDataString = '';
    List fileDataList = [];

    if (!await file.exists()) {
      //File newFile = await File(_path).create().then((File file) async {
      // return file.writeAsString(await File(backUpPath).readAsString());
      //});

      File newFile = await File(
        _path,
      ).writeAsString(await File(backUpPath).readAsString());

      fileDataString = await newFile.readAsString();
    } else {
      fileDataString = await file.readAsString();
    }

    fileDataList = jsonDecode(fileDataString);

    return fileDataList.map((items) => items as Map<String, dynamic>).toList();
  }

  @override
  Future<void> writeTodos(List<Map<String, dynamic>> todos) async {
    File file = File(_path);
    File backFile = File(backUpPath);
    File newBackFile = File(backUpPath);

    if (!await backFile.exists()) {
      newBackFile = await File('data/backup.dat').copy(backUpPath);
    }

    String encodeJson = jsonEncode(todos);

    await file.writeAsString(encodeJson);
    await newBackFile.writeAsString(encodeJson);
  }
}
