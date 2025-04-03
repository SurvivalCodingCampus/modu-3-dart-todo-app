import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:todo_app/data_source/todo_data_source.dart';

import '../mock/mock_todo_data_source.dart';
import '../mock/mock_todo_data_source_impl.dart';

void main() async {
  const String filePath = 'data/todos2.json';

  Future<List<Map<String, dynamic>>> readFile({required String path}) async {
    List readFileList = jsonDecode(await File(path).readAsString());
    List<Map<String, dynamic>> readFileData =
        readFileList.map((items) => items as Map<String, dynamic>).toList();

    return readFileData;
  }

  test("1. 파일 미존재 시 – 자동 파일 생성 및 백업 사용", () async {
    TodoDataSource todoDataSource = MockTodoDataSourceImpl(path: filePath);
    List<Map<String, dynamic>> getDataSource = await todoDataSource.readTodos();

    expect(getDataSource, equals(await readFile(path: 'data/backup.dat')));
  });

  test("2. readTodos() – 정상 파일에서 데이터 읽기", () async {
    TodoDataSource todoDataSource = MockTodoDataSourceImpl(path: filePath);
    List<Map<String, dynamic>> getDataSource = await todoDataSource.readTodos();
    expect(getDataSource, equals(await readFile(path: 'data/todos2.json')));
  });

  test("3. writeTodos() – 데이터 파일에 쓰기", () async {
    List<Map<String, dynamic>> readData =
        await MockTodoDataSourceImpl(path: filePath).readTodos();
    List<Map<String, dynamic>> mockData = MockTodoDataSource().data;

    File testFile = File('data/todos2.json');

    await testFile.writeAsString(jsonEncode([...readData, ...mockData]));

    expect(
      await readFile(path: 'data/todos2.json'),
      equals([...readData, ...mockData]),
    );

    if (await File('data/backup2.dat').exists()) {
      await File('data/backup2.dat').delete();
    }

    await testFile.delete();
  });
}
