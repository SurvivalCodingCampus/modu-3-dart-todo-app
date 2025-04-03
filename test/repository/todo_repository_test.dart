import 'package:test/test.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/repository/todo_repository_impl.dart';

import '../mock/mock_todo_data_source.dart';

void main() {
  late TodoRepository todoRepository;

  group('투두 : ', () {
    setUp(() {
      todoRepository = TodoRepositoryImpl(datasource: MockTodoDataSource());
    });

    test('전체 조회', () async {
      List<Todo> todos = await todoRepository.getTodos();

      expect(todos.length, 3);
      expect(todos.first.id, 1);
      expect(todos.first.title, 'test');
    });

    test('투두 추가', () async {
      await todoRepository.addTodo('test4');
      List<Todo> todos = await todoRepository.getTodos();

      expect(todos.length, 4);
      expect(todos.last.id, 4);
      expect(todos.last.title, 'test4');
    });

    test('투두 수정', () async {
      await todoRepository.updateTodo(1, 'test updated');
      List<Todo> todos = await todoRepository.getTodos();

      expect(todos.length, 3);
      expect(todos.first.id, 1);
      expect(todos.first.title, 'test updated');
    });

    test('투두 토글', () async {
      List<Todo> todos = await todoRepository.getTodos();
      Todo todo = todos.firstWhere((element) => element.id == 1);

      await todoRepository.toggleTodo(1);

      expect(
        (await todoRepository.getTodos())
            .firstWhere((element) => element.id == 1)
            .completed,
        !todo.completed,
      );
    });

    test('투두 삭제', () async {
      await todoRepository.deleteTodo(1);
      List<Todo> todos = await todoRepository.getTodos();

      expect(todos.length, 2);
      expect(todos.first.id, 2);
      expect(todos.first.title, 'test2');
    });

    test('투두 완료만 보기', () async {
      List<Todo> todos = await todoRepository.getTodosByCompleted(true);

      expect(todos.length, 2);
      expect(todos.first.id, 1);
      expect(todos.first.completed, true);
    });
    test('투두 미완료만 보기', () async {
      List<Todo> todos = await todoRepository.getTodosByCompleted(false);

      expect(todos.length, 1);
      expect(todos.first.id, 3);
      expect(todos.first.completed, false);
    });
  });
}
