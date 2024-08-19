import 'dart:convert';

import 'package:sff_lib/config.dart';

class Json implements ILexer {
  @override
  Map lexer(String input) => jsonDecode(input) as Map;
}
