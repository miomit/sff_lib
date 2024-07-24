import 'package:sff_lib/filesystem.dart';

abstract class FSEntity {
  String get name;
  Future<Stat> get stat;
  Stat get statSync;
}
