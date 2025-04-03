class CliTextConstants {
  // 명령어 목록 및 메뉴 구성
  static const String menuShowTodos = '📋 목록 보기';
  static const String menuAddTodo = '➕ 할 일 추가';
  static const String menuUpdateTodo = '✏️ 할 일 수정';
  static const String menuToggleTodo = '🔄 완료 상태 토글';
  static const String menuDeleteTodo = '🗑️ 할 일 삭제';
  static const String menuCommandExit = '❌ 종료';
  static const String menuHeader = '=== 📝 TODO LIST 프로그램 ===';
  static const String menuFooter = '============================';
  static const String menuWideLine =
      '══════════════════════════════════════════════════════════════════════════════════════════════════════';

  // 정렬/필터 선택 안내
  static const String menuFilterHeader = '📂 정렬/필터를 선택하세요:';
  static const String menuFilterDateAsc = '📅 날짜순 오름차순';
  static const String menuFilterDateDesc = '📅 날짜순 내림차순';
  static const String menuFilterCompleted = '✅ 완료된 할 일만 보기';
  static const String menuFilterIncomplete = '⬜ 미완료 할 일만 보기';

  // 안내문
  static const String todoFormatGuide =
      '[ 번호 / [✅] 체크된 완료 상태 /  할 일 제목 / 📅 (날짜 형식)]';
  static const String invalidInput = '[⚠️ !!! 잘못된 입력입니다. 다시 시도하세요. !!! ⚠️]';
  static const String todoAdded = '[✅ 할 일 추가됨]';
  static const String todoIdNotFound = '[⚠️ 해당 ID의 할 일이 존재하지 않습니다.]';
  static const String noTodoMessage = '[📭 할 일이 없습니다.]';
  static const String todoUpdated = '[✏️ 할 일 제목이 수정되었습니다]';
  static const String enterToggleIdPrompt = '[🔄 완료 상태를 토글할 할 일 ID를 입력하세요]';
  static const String todoToggled = '[🔄 할 일 완료 상태가 변경되었습니다]';
  static const String todoDeleted = '[🗑️ 할 일이 삭제되었습니다]';
  static const String programStart = '🚀 프로그램 시작';
  static const String programExit = '🚪 프로그램 종료';

  // 사용자 입력
  static const String promptChoice = '🔢 선택하세요: ';
  static const String promptFilterChoice = '🔢 필터를 선택하세요: ';
  static const String enterTitle = '📝 할 일 제목을 입력하세요: ';
  static const String enterUserId = '👤 사용자 ID를 입력하세요: ';
  static const String enterTodoId = '🔑 수정할 할 일 ID를 입력하세요: ';
  static const String enterNewTitle = '✏️ 새 제목을 입력하세요: ';
  static const String enterToggleId = '🔄 토글할 할 일 ID를 입력하세요: ';
  static const String enterDeleteId = '🗑️ 삭제할 할 일 ID를 입력하세요: ';
}

enum CliCommand {
  showTodos,
  addTodo,
  updateTodo,
  toggleTodo,
  deleteTodo,
  appExit,
}

CliCommand? parseCliCommand(String? input) {
  switch (input) {
    case '1':
      return CliCommand.showTodos;
    case '2':
      return CliCommand.addTodo;
    case '3':
      return CliCommand.updateTodo;
    case '4':
      return CliCommand.toggleTodo;
    case '5':
      return CliCommand.deleteTodo;
    case '0':
      return CliCommand.appExit;
    default:
      return null;
  }
}
