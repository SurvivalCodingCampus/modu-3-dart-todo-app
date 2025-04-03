enum LogCondition {
  show,
  add,
  update,
  toggle,
  delete,
  end;

  static LogCondition convertLogCondition(String value) {
    switch (value) {
      case '1':
        return LogCondition.show;
      case '2':
        return LogCondition.add;
      case '3':
        return LogCondition.update;
      case '4':
        return LogCondition.toggle;
      case '5':
        return LogCondition.delete;
      case '0':
        return LogCondition.end;
      default:
        throw Exception('잘못된 번호입니다.');
    }
  }
}
