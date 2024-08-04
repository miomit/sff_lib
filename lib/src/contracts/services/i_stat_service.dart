import 'package:option_result/option.dart';

/// Metadata for a file or directory.
abstract interface class IStatService {
  String get name;
  int get size;
  DateTime get created;

  /// Physical path of an entity in the presence of.
  Option<String> get realPath;
}
