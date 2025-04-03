import 'package:test/test.dart';
import 'package:todo_app/data_source/todo_data_source.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/repository/todo_repository_impl.dart';

List<Map<String, dynamic>> mockTodos = [
    {
      "userId": 1,
      "id": 2,
      "title": "dfd",
      "completed": false,
      "createdAt": "2025-03-30 08:30:00.000Z",
    },
    {
      "userId": 1,
      "id": 3,
      "title": "다른 사람 코드 리뷰하기",
      "completed": true,
      "createdAt": "2025-03-31 14:00:00.000Z",
    },
    {
      "userId": 1,
      "id": 4,
      "title": "TIL 정리하기",
      "completed": true,
      "createdAt": "2025-04-01 09:45:00.000Z",
    },
    {
      "userId": 1,
      "id": 5,
      "title": "인프런 강의 시청",
      "completed": false,
      "createdAt": "2025-04-02 07:20:00.000Z",
    },
    {
      "userId": 1,
      "id": 7,
      "title": "Hello",
      "completed": false,
      "createdAt": "2025-04-02 16:43:48.313068",
    },
    {
      "userId": 1,
      "id": 8,
      "title": "과제 끝내줘..",
      "completed": false,
      "createdAt": "2025-04-02 17:27:13.250075",
    },
    {
      "userId": 1,
      "id": 9,
      "title": "ㅎㅇ",
      "completed": false,
      "createdAt": "2025-04-02 17:29:37.587091",
    },
    {
      "userId": 1,
      "id": 10,
      "title": "",
      "completed": false,
      "createdAt": "2025-04-02 17:36:10.432440",
    },
    {
      "userId": 1,
      "id": 11,
      "title": "Hello World!",
      "completed": false,
      "createdAt": "2025-04-02 17:48:27.893054",
    },
];

class MockTodoDataSource implements TodoDataSource {
  @override
  Future<List<Map<String, dynamic>>> readTodos() async {
    return mockTodos;
  }

  @override
  Future<void> writeTodos(List<Map<String, dynamic>> todos) async {
    mockTodos = todos;
  }
}

void main() {
  late TodoDataSource dataSource;
  late TodoRepository repository;

  setUpAll(() {
    dataSource = MockTodoDataSource();
    repository = TodoRepositoryImpl(todoDataSource: dataSource);
  });

  group('Todo Repository Test', () {
    test('정상적으로 Todo가 추가되어야 한다', () async {
      const title = 'Hello World!';
      await repository.addTodo(title);

      final newTodo =
          (await repository.getTodos()).where((e) => e.title == title).first;

      expect(newTodo.title, equals(title));
    });

    test('정상적으로 Todos를 읽어와야한다.', () async {
      final todos = await repository.getTodos();
      final newMockTodos = mockTodos.map((e) => Todo.fromJson(e)).toList();

      expect(todos.length, equals(mockTodos.length));
      expect(todos, equals(newMockTodos));
    });

    test('Todo를 정상적으로 업데이트 해야 한다.', () async {
      const newTitle = 'Hello Foo!';
      const id = 2;
      await repository.updateTodo(id, newTitle);
      final todos = await repository.getTodos();

      expect(todos.where((e) => e.id == id).first.title, equals(newTitle));
    });

    test('Todo Toggle이 정상적으로 업데이트 동작해야 된다.', () async {
      const id = 2;
      final beforeComplete = (await repository.getTodos()).where((e) => e.id == id).first.completed;
      
      await repository.toggleTodo(id);
      final afterComplete = (await repository.getTodos()).where((e) => e.id == id).first.completed;

      expect(beforeComplete, equals(!afterComplete));
    });

    test('Todo 삭제가 정상적으로 동작해야 된다.', () async {
      const id = 2;
      final beforeCount = (await repository.getTodos()).length;

      await repository.deleteTodo(id);
      final afterCount = (await repository.getTodos()).length;
      final isExist = (await repository.getTodos()).any((e) => e.id == id);

      expect(beforeCount, equals(afterCount + 1));
      expect(isExist, isFalse);
    });
  });
}
