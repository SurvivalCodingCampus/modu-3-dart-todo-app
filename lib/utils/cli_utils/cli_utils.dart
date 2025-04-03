import 'dart:io';
import 'package:todo_app/utils/cli_utils/cli_text_constants.dart';
import 'package:todo_app/utils/logs/app_log.dart';
import '../../model/todo.dart';
import '../../repository/todo_repository.dart';

class CliUtils {
  final TodoRepository repository;
  final AppLog logger;

  CliUtils({required this.repository, required this.logger});

  final String strMenu = '''
${CliTextConstants.menuHeader}
  [1]. ${CliTextConstants.menuShowTodos}
  [2]. ${CliTextConstants.menuAddTodo}
  [3]. ${CliTextConstants.menuUpdateTodo}
  [4]. ${CliTextConstants.menuToggleTodo}
  [5]. ${CliTextConstants.menuDeleteTodo}
  [0]. ${CliTextConstants.menuCommandExit}
${CliTextConstants.menuFooter}
''';

  final String strMenuFilterOptions = '''
${CliTextConstants.menuFilterHeader}
  [1]. ${CliTextConstants.menuFilterDateAsc}
  [2]. ${CliTextConstants.menuFilterDateDesc}
  [3]. ${CliTextConstants.menuFilterCompleted}
  [4]. ${CliTextConstants.menuFilterIncomplete}
''';

  /// === 공통 유틸 함수 ===
  // 입력이 null이거나 공백 문자열인지 검사
  bool isNullOrBlank(String? str) => str == null || str.trim().isEmpty;

  // 숫자인 문자열인지 검사 (null 또는 공백일 경우 false)
  bool isNumeric(String? str) =>
      !(isNullOrBlank(str)) && num.tryParse(str!.trim()) != null;

  // ID 문자열을 int로 변환하고 실제 존재하는 할 일인지 검사하여 유효한 ID 반환
  Future<int?> getValidTodoId(String? input) async {
    if (!isNumeric(input)) return null;

    final int id = int.parse(input!.trim());
    final todos = await repository.getTodos();
    final exists = todos.any((todo) => todo.id == id);
    return exists ? id : null;
  }

  /// 로그 함수

  Future<void> printMessageWithWriteLog({
    String? command,
    String cliText = CliTextConstants.invalidInput,
  }) async {
    print(cliText);
    if (cliText == CliTextConstants.todoIdNotFound) {
      await logger.log('오류 - 유효 하지 않는 Todo id 값 입력 [$command] : $cliText');
    } else if (cliText == CliTextConstants.programStart) {
      await logger.log('앱 시작됨.');
    } else if (cliText == CliTextConstants.programExit) {
      await logger.log('앱 종료됨.');
    } else if (cliText == CliTextConstants.todoAdded) {
      await logger.log('할 일 추가됨 - 제목 : \'$command\'');
    } else if (cliText == CliTextConstants.todoUpdated) {
      await logger.log('할 일 제목 수정 - \'$command\'');
    } else if (cliText == CliTextConstants.todoToggled) {
      await logger.log('할 일 완료 토글 - ID: $command, 상태: 완료됨');
    } else if (cliText == CliTextConstants.todoDeleted) {
      await logger.log('할 일 삭제됨 - ID: $command');
    } else if (cliText == CliTextConstants.invalidInput) {
      await logger.log('오류 - 유효 하지 않는 문자열 입력 [$command] : $cliText');
    } else {
      final errorMsg =
          '오류 - [CliCommandException] 정의 되지 않는 Cli 로그 메시지 (command: $command, cliText: $cliText)';
      await logger.log(errorMsg);
      throw Exception(errorMsg);
    }
  }

  /// === 사용자 명령 처리 루프 ===
  // 메인 루프: 사용자 명령 처리
  Future<void> processCommand() async {
    await printMessageWithWriteLog(cliText: CliTextConstants.programStart);
    while (true) {
      print(strMenu);

      stdout.write(CliTextConstants.promptChoice);
      final choice = stdin.readLineSync();

      if (isNullOrBlank(choice)) {
        await printMessageWithWriteLog(command: choice);
        continue;
      }

      switch (choice) {
        case '1':
          await selectAndShowTodos();
          break;
        case '2':
          await addTodo();
          break;
        case '3':
          await updateTodo();
          break;
        case '4':
          await toggleTodo();
          break;
        case '5':
          await deleteTodo();
          break;
        case '0':
          await printMessageWithWriteLog(cliText: CliTextConstants.programExit);
          return;
        default:
          await printMessageWithWriteLog(command: choice);
          break;
      }
    }
  }

  Future<void> selectAndShowTodos() async {
    final todos = await repository.getTodos();

    print(strMenuFilterOptions);
    stdout.write(CliTextConstants.promptFilterChoice);
    final choice = stdin.readLineSync();

    List<Todo> filtered = todos;
    switch (choice) {
      case '1':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case '2':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case '3':
        filtered = todos.where((todo) => todo.completed).toList();
        break;
      case '4':
        filtered = todos.where((todo) => !todo.completed).toList();
        break;
      default:
        break;
    }

    await showTodos(todos: filtered);
  }

  /// === 할 일 처리 함수 ===
  // 할 일 목록 보기
  Future<void> showTodos({List<Todo>? todos}) async {
    final data = todos ?? await repository.getTodos();

    if (data.isEmpty) {
      await printMessageWithWriteLog(cliText: CliTextConstants.noTodoMessage);
      return;
    }
    print(CliTextConstants.menuWideLine);
    for (Todo todo in data) {
      final formattedDate = todo.createdAt.toString();
      final formattedId = todo.id.toString().padLeft(3, ' ');
      final formattedTitle = todo.title.toString().padRight(30, ' ');
      print(
        '$formattedId. [${todo.completed ? '✅' : '⬜'}] $formattedTitle 📅($formattedDate)',
      );
    }
    print(CliTextConstants.menuWideLine);
    print(CliTextConstants.todoFormatGuide);
  }

  // 할 일 추가
  Future<void> addTodo() async {
    stdout.write(CliTextConstants.enterTitle);
    final String? inputTitle = stdin.readLineSync();

    if (!isNullOrBlank(inputTitle) && !isNumeric(inputTitle)) {
      await repository.addTodo(inputTitle!.trim());
      await printMessageWithWriteLog(
        command: inputTitle,
        cliText: CliTextConstants.todoAdded,
      );
    } else {
      await printMessageWithWriteLog(command: inputTitle);
    }
  }

  // 할 일 수정
  Future<void> updateTodo() async {
    stdout.write(CliTextConstants.enterTodoId);
    final String? inputId = stdin.readLineSync();

    final int? id = await getValidTodoId(inputId);
    if (id == null) {
      await printMessageWithWriteLog(
        command: inputId,
        cliText: CliTextConstants.todoIdNotFound,
      );
      return;
    }

    print(CliTextConstants.enterNewTitle);
    final String? inputTitle = stdin.readLineSync();

    if (!isNullOrBlank(inputTitle) && !isNumeric(inputTitle)) {
      await repository.updateTodo(id, inputTitle!.trim());
      print(CliTextConstants.todoUpdated);
      await printMessageWithWriteLog(
        command: 'ID: $inputTitle, 새로운 제목: $id',
        cliText: CliTextConstants.todoUpdated,
      );
    } else {
      await printMessageWithWriteLog(command: inputTitle);
    }
  }

  // 완료 상태 토글
  Future<void> toggleTodo() async {
    stdout.write(CliTextConstants.enterToggleId);
    final String? inputId = stdin.readLineSync();

    final int? id = await getValidTodoId(inputId);
    if (id == null) {
      await printMessageWithWriteLog(
        command: inputId,
        cliText: CliTextConstants.todoIdNotFound,
      );
      return;
    }

    await repository.toggleTodo(id);

    await printMessageWithWriteLog(
      command: inputId,
      cliText: CliTextConstants.todoToggled,
    );
  }

  // 할 일 삭제
  Future<void> deleteTodo() async {
    stdout.write(CliTextConstants.enterDeleteId);
    final String? inputId = stdin.readLineSync();

    final int? id = await getValidTodoId(inputId);
    if (id == null) {
      await printMessageWithWriteLog(
        command: inputId,
        cliText: CliTextConstants.todoIdNotFound,
      );
      return;
    }

    await repository.deleteTodo(id);
    await printMessageWithWriteLog(
      command: inputId,
      cliText: CliTextConstants.todoDeleted,
    );
  }
}
