import 'dart:collection';

import 'package:sff_lib/log.dart';

class LogStack {
  final _stack = Queue<Log>();

  int get length => _stack.length;
  bool canPop() => _stack.isNotEmpty;

  final bool autoPrint;

  LogStack({this.autoPrint = false});

  void clear() {
    while (_stack.isNotEmpty) {
      _stack.removeLast();
    }
  }

  void push(Log log) {
    _stack.addLast(log);
    if (autoPrint) {
      print(log);
    }
  }

  Log pop() {
    Log lastLog = _stack.last;
    _stack.removeLast();
    return lastLog;
  }

  Log peak() => _stack.last;
}
