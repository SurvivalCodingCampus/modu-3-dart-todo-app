class Action {
  final bool shouldExit;

  const Action({this.shouldExit = false});

  static const Action exit = Action(shouldExit: true);
  static const Action continueAction = Action(shouldExit: false);
}
