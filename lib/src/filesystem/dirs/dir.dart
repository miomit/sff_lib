import 'package:sff_lib/filesystem.dart';

abstract class Dir extends FSEntity {
  Stream<FSEntity> list({
    bool recursive = false,
    void Function(Exception e, FSEntity fse)? onException,
  });

  Future<Dir?> mkdir(String name);
  Dir? mkdirSync(String name);

  Future<File?> touch(String name);
  File? touchSync(String name);
}
