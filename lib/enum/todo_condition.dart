enum TodoCondition {
  base,
  isAscending,
  isDescending,
  isCompleted,
  isNotCompleted
}

extension TodoConditionExtension on TodoCondition {
  String get name {
    return switch (this) {
      TodoCondition.base => '',
      TodoCondition.isAscending => '오름차순',
      TodoCondition.isDescending => '내림차순',
      TodoCondition.isCompleted => '완셩된',
      TodoCondition.isNotCompleted => '미 완성된',
    };
  }
}