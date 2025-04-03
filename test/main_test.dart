
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:todo_app/data_source/todo_data_source.dart';
import 'package:todo_app/data_source/todo_data_source_impl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/repository/todo_repository_impl.dart';

void main(){
  final String path = 'lib/data/mock_todos.json';
  final TodoDataSource todoDataSource = TodoDataSourceImpl(path: path);
  final TodoRepository todoRepository = TodoRepositoryImpl(dataSource: todoDataSource);

  test('1. 목록 보기', () async {
    List<Todo> getTodos = await todoRepository.getTodos();

    expect(getTodos.length, 2);
  });
  test('2. 할 일 추가', () async {
    const title = '제목';

    List<Todo> originalTodos = await todoRepository.getTodos();

    await todoRepository.addTodo(title);
    List<Todo> getTodos = await todoRepository.getTodos();

    expect(originalTodos.length + 1, getTodos.length);
  });
  test('3. 할 일 수정', () async {
    const title = '제목2';

    List<Todo> originalTodos = await todoRepository.getTodos();
    final firstId = originalTodos.first.id;
    await todoRepository.updateTodo(firstId, title);

    List<Todo> getTodos = await todoRepository.getTodos();

    expect(getTodos.first.title, title);
  });
  test('4. 완료 상태 토글', () async {

    List<Todo> originalTodos = await todoRepository.getTodos();
    final firstId = originalTodos.first.id;
    await todoRepository.toggleTodo(firstId);

    List<Todo> getTodos = await todoRepository.getTodos();

    expect(originalTodos.first.completed, !getTodos.first.completed);
  });
  test('5. 할 일 삭제', () async {

    List<Todo> originalTodos = await todoRepository.getTodos();

    await todoRepository.deleteTodo(originalTodos.first.id);
    List<Todo> getTodos = await todoRepository.getTodos();

    expect(originalTodos.length - 1, getTodos.length);
  });
  test('6. 생성일순 정렬', () async {

    List<Todo> todos = await todoRepository.sortedWithCreatedAtTodo();

    for (int i = 0; i < todos.length - 1; i++) {
      expect(todos[i].createdAt.isBefore(todos[i+1].createdAt), isTrue);
    }
  });
  test('7-1. 완료또는 미완료 할일만 보기', () async {

    final todos = await todoRepository.selectedWithCompletedTodo(
      true,
    );
    expect(todos.any((e) => e.completed == false), isFalse);
  });
  test('7-2. 완료또는 미완료 할일만 보기', () async {

    final todos = await todoRepository.selectedWithCompletedTodo(
      false,
    );
    expect(todos.any((e) => e.completed == true), isFalse);
  });
}
