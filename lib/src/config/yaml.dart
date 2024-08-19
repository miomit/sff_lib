import 'package:sff_lib/config.dart';
import 'package:yaml/yaml.dart' show loadYaml;

class Yaml implements ILexer {
  @override
  Map lexer(String input) => loadYaml(input) as Map;
}
