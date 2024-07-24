import 'package:sff_lib/filesystem.dart';

abstract class File extends FSEntity {
  Stream<List<int>> openRead();
}
