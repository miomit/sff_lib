import 'package:sff_lib/filesystem.dart';

abstract class FSEntity {
  Future<Stat> get stat;
  Stat get statSync;
}
