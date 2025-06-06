import 'dart:convert';

import 'package:todo_app/data_source/todo_data_source.dart';

class MockTodoDatasourceImpl implements TodoDataSource {
  String _mockJsonString = '''
  [
  {
    "userId": 1,
    "id": 1,
    "title": "생존코딩 유튜브 구독하기",
    "completed": false,
    "createdAt": "2025-03-29T10:15:00Z"
  },
  {
    "userId": 1,
    "id": 2,
    "title": "PR 제출하기",
    "completed": false,
    "createdAt": "2025-03-30T08:30:00Z"
  },
  {
    "userId": 1,
    "id": 3,
    "title": "다른 사람 코드 리뷰하기",
    "completed": false,
    "createdAt": "2025-03-31T14:00:00Z"
  },
  {
    "userId": 1,
    "id": 4,
    "title": "TIL 정리하기",
    "completed": true,
    "createdAt": "2025-04-01T09:45:00Z"
  },
  {
    "userId": 1,
    "id": 5,
    "title": "인프런 강의 시청",
    "completed": false,
    "createdAt": "2025-04-02T07:20:00Z"
  }
]
  ''';

  @override
  Future<List<Map<String, dynamic>>> readTodo() async {
    final List<dynamic> decoded = json.decode(_mockJsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<void> writeTodo(List<Map<String, dynamic>> todos) async {
    _mockJsonString = json.encode(todos);
  }
}
