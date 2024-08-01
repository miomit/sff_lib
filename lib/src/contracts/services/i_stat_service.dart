import 'package:option_result/option.dart';

abstract interface class IStatService {
  String get name;
  int get size;
  DateTime get created;

  Option<String> get realPath;
}