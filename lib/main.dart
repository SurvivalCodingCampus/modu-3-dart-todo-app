import 'dart:io';

import 'data_source/todo_data_source.dart';
import 'data_source/todo_data_source_impl.dart';
import 'logs/logs.dart';
import 'model/todo.dart';
import 'repository/todo_repository.dart';
import 'repository/todo_repository_impl.dart';

void showMenu() {
  print("""
    === TODO LIST 프로그램 ===
    1. 목록 보기
    2. 할 일 추가
    3. 할 일 수정
    4. 완료 상태 토글
    5. 할 일 삭제
    6. 생성일순 정렬
    7. 완료또는 미완료 할일만 보기
    0. 종료
    --------------------------
    """);

  print('선택하세요:');
}

void main() async {
  writeLogs('앱 시작됨.');
  TodoDataSource mockTodoDataSource = TodoDataSourceImpl(
    path: 'lib/data/mock_todos.json',
  );
  TodoRepository todoRepository = TodoRepositoryImpl(
    dataSource: mockTodoDataSource,
  );

  while (true) {
    showMenu();
    String? num = stdin.readLineSync();
    if (num == '1') {
      List<Todo> todos = await todoRepository.getTodos();
      print('[할 일 목록]');
      for (final todo in todos) {
        print(
          '${todo.id}. [${todo.completed == true ? 'X' : ''}] ${todo.title} (${todo.createdAt.toIso8601String().split('.').first}Z)',
        );
      }
    } else if (num == '2') {
      print('할 일 제목을 입력하세요: ');
      String? title = stdin.readLineSync();

      if (title != null) {
        await todoRepository.addTodo(title);
        print('[할 일 추가됨]');
      }
    } else if (num == '3') {
      print('수정할 할 일 ID를 입력하세요: ');
      String? id = stdin.readLineSync();
      print('새 제목을 입력하세요: ');
      String? title = stdin.readLineSync();
      if (id != null && title != null) {
        await todoRepository.updateTodo(int.parse(id), title);
        print('[할 일 제목이 수정되었습니다]');
      }
    } else if (num == '4') {
      print('완료 상태를 토글할 할 일 ID를 입력하세요: ');
      String? id = stdin.readLineSync();
      if (id != null) {
        await todoRepository.toggleTodo(int.parse(id));
        print('[할 일 완료 상태가 변경되었습니다]');
      }
    } else if (num == '5') {
      print('삭제할 할 일 ID를 입력하세요: ');
      String? id = stdin.readLineSync();
      if (id != null) {
        await todoRepository.deleteTodo(int.parse(id));
        print('[할 일이 삭제되었습니다]');
      }
    } else if (num == '6') {
      final todos = await todoRepository.sortedWithCreatedAtTodo();
      print('[정렬된 할 일 목록]');
      for (final todo in todos) {
        print(
          '${todo.id}. [${todo.completed == true ? 'X' : ''}] ${todo.title} (${todo.createdAt.toIso8601String().split('.').first}Z)',
        );
      }
    } else if (num == '7') {
      print('완료된 리스트 : true, 완료 안된 리스트 : false를 입력하세요: ');
      String? completed = stdin.readLineSync();
      if (completed != null) {
        final todos = await todoRepository.selectedWithCompletedTodo(
          bool.parse(completed),
        );
        print('[정렬된 할 일 목록]');
        for (final todo in todos) {
          print(
            '${todo.id}. [${todo.completed == true ? 'X' : ''}] ${todo.title} (${todo.createdAt.toIso8601String().split('.').first}Z)',
          );
        }
      } else {
        throw Exception('true, false 중 입력해주세요');
      }
      
    } else if (num == '0') {
      List<Todo> todos = await todoRepository.getTodos();
      print('[할 일 목록]');
      for (final todo in todos) {
        print(
          '${todo.id}. [${todo.completed == true ? 'X' : ''}] ${todo.title} (${todo.createdAt.toIso8601String().split('.').first}Z)',
        );
      }
      print('종료전 마지막 수정사항을 저장하시겠습니까? (y/n)');
      String? answer = stdin.readLineSync();

      if(answer == 'y') {
        await mockTodoDataSource.writeTodos(todos.map((e) => e.toJson()).toList());

        print('[프로그램을 종료합니다. 데이터가 저장되었습니다.]');
        writeLogs('앱 종료됨.');

        break;
      }
    }
  }
}
