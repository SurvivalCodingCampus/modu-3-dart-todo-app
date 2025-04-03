import 'dart:convert';
import 'dart:io';

import 'package:todo_app/data_source/impl/todo_data_source_impl.dart';
import 'package:todo_app/repository/impl/todo_repository_impl.dart';
import 'package:intl/intl.dart';
import 'data_source/local/todo_data_source.dart';
import 'model/todo.dart';

void main() async {
  final filePath = r'lib/data/';
  final backUpFilePath = r'lib/data/';

  final TodoDataSource todoDataSource = TodoDataSourceImpl(
    filePath: filePath + 'todos.json',
    backUpFilePath: backUpFilePath + 'backup.dat'
  );


  final todoRepository = TodoRepositoryImpl(todoDataSource);
  await todoRepository.writeLogTodo('앱 시작됨.');

  while (true) {
    print('===== 일 목록 보기 =====');
    print('1. 목록 보기');
    print('2. 할 일 추가');
    print('3. 할 일 수정');
    print('4. 완료 상태 토글');
    print('5. 할 일 삭제');
    print('6. 날짜 정렬보기');
    print('7. 완료/미완료 보기');
    print('0. 종료');
    print('======================');

    stdout.write('선택하세요: ');
    final input = stdin.readLineSync();

    switch (input) {
      case '1':
        final todos = await todoRepository.getTodos();
        _printTodos(todos);
        //print('$todos');  // 이쁘게 보이게 수정 메서드 작성
        break;
      case '2':
        stdout.write('할 일을 입력하세요: ');
        final newTitle = stdin.readLineSync(encoding: Utf8Codec());
        if (newTitle == '') {
          print('할 일이 입력되지 않았습니다.');
        } else {
          await todoRepository.addTodo(newTitle ?? '');
          print('할일 추가됨');
        }
        break;
      case '3':
        stdout.write('수정할 ID를 입력하세요: ');
        final id = int.tryParse(stdin.readLineSync() ?? '');

        final todosIdList = await todoRepository.getTodosIdList();
        if (todosIdList.any((e) => e == id)) {
          stdout.write('수정할 제목을 입력하세요: ');
          final title = stdin.readLineSync(encoding: Utf8Codec());

          await todoRepository.updateTodo(id ?? 0, title ?? '');
        } else {
          print('수정 할 ID가 없습니다.');
        }

        break;
      case '4': //delete
        stdout.write('완료 상태를 토글할 할 일 ID를 입력하세요: ');
        final id = int.tryParse(stdin.readLineSync() ?? '');
        final todosIdList = await todoRepository.getTodosIdList();
        if (todosIdList.any((e) => e == id)) {
          await todoRepository.toggleTodo(id ?? 0);
          stdout.write('할 일 완료 상태를 변경하였습니다.');
        } else {
          print('토글 할 ID가 없습니다.');
        }
        break;
      case '5':
        stdout.write('삭제 할 ID를 입력하세요:');
        final id = int.tryParse(stdin.readLineSync() ?? '');
        final todosIdList = await todoRepository.getTodosIdList();
        if (todosIdList.any((e) => e == id)) {
          await todoRepository.deleteTodo(id ?? 0);
        } else {
          print('삭제 할 ID가 없습니다.');
        }
        break;
      case '6':
        stdout.write('데이터를 최신순으로 보고 싶으면 1번 등록순이면 2번을 눌러주세요.');
        final choice = int.tryParse(stdin.readLineSync() ?? '');
        if (choice == 1 || choice == 2) {
          final sortedData = await todoRepository.getSortedDate(choice ?? 0);
          _printTodos(sortedData);
        } else {
          print('잘못된 입력입니다.');
        }
        break;
      case '7':
        stdout.write('완료 상태를 보고 싶으면 1번 미완료 상태를 보고 싶으면 2번을 눌러주세요.');
        final choice = int.tryParse(stdin.readLineSync() ?? '');
        if (choice == 1 || choice == 2) {
          _printTodos(await todoRepository.getToggleTodo(choice ?? 0));
        } else {
          print('잘못된 입력입니다.');
        }
        break;
      case '0':
        print('프로그램을 종료합니다. 데이터가 저장되었습니다.');
        await todoRepository.writeLogTodo('앱 종료됨.');
        exit(0);
      default:
        print('해당 메뉴는 지원하지 않습니다. 다시 눌러주세요.');
    }
  }
}

void _printTodos(List<Todo> todos) {
  print('======================');
  print('====== 할 일 목록 ======');
  print('======================');
  final formatCreatedAt = DateFormat('yyyy-MM-dd HH:mm');
  if (todos.isNotEmpty) {
    for (Todo todo in todos) {
      String checked = todo.completed ? '[✔]' : '[ ]';
      print(
        '${todo.id}. $checked ${todo.title} (${formatCreatedAt.format(todo.createdAt)})',
      );
    }
  } else {
    print('할 일이 없습니다.');
  }
  print('======================');
}
