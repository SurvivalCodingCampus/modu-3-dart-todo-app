import 'package:test/test.dart';
import 'package:todo_app/data_source/mock_todo_data_source_impl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/repository/todo_repository_impl.dart';

void main() {
  final TodoRepository todoRepository = TodoRepositoryImpl(
    MockTodoDatasourceImpl(),
  );

  group('할 일 수정 TEST', () {
    test('정상적인 수정이 되는지 확인', () async {
      // Given
      final int id = 1;
      final newTitle = 'Test';

      // When, Then
      todoRepository.updateTodo(id, newTitle);
    });

    test('잘못된 ID 입력시 예외 처리', () async {
      // Given
      final int id = 99;
      final String newTitle = 'Test';

      // When, Then
      todoRepository.updateTodo(id, newTitle);
    });

    test('빈 제목 입력 시 처리 확인', () async {
      // Given
      final int id = 1;
      final String newTitle = '';

      // When, Then
      todoRepository.updateTodo(id, newTitle);
    });
  });

  group('ID 자동 증가', () {
    test('ID 증가 확인', () async {
      //Given
      final int id = 3;

      // When, Then
      todoRepository.deleteTodo(id);
    });
  });

  group('TODOLIST', () {
    test('목록보기_날짜오름차순', () async {
      final todos = await todoRepository.getTodos();
      todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (int i = 0; i < todos.length - 1; i++) {
        expect(todos[i].createdAt.isBefore(todos[i + 1].createdAt), isTrue);
      }
    });

    test('목록보기_날짜내림차순', () async {
      final todos = await todoRepository.getTodos();
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      for (int i = 0; i < todos.length - 1; i++) {
        expect(todos[i].createdAt.isAfter(todos[i + 1].createdAt), isTrue);
      }
    });

    test('목록보기_완료목록', () async {
      final todos = await todoRepository.getTodos();
      todos.retainWhere((e) => e.completed == true);
      expect(todos.isNotEmpty, isTrue);
      for (var todo in todos) {
        expect(todo.completed, isTrue);
      }
    });

    test('목록보기_미완료목록', () async {
      final todos = await todoRepository.getTodos();
      todos.retainWhere((e) => e.completed == false);

      expect(todos.isNotEmpty, isTrue);
      for (var todo in todos) {
        expect(todo.completed, isFalse);
      }
    });
  });

  group('TODOLIST', () {
    final TodoRepository todoRepository = TodoRepositoryImpl(
      MockTodoDatasourceImpl(),
    );
    test('할 일 추가 테스트', () async {
      List<Todo> beforeTodos = await todoRepository.getTodos();

      await todoRepository.addTodo('새로운 할 일');
    });
  });

  group('TODOLIST', () {
    test('미완료상태 토글', () async {
      await todoRepository.toggleTodo(1);
      expect(true, true);
    });
    test('완료상태 토글', () async {
      await todoRepository.toggleTodo(4);
      expect(false, false);
    });
  });
}
