import 'package:sff_lib/filesystem.dart';

abstract class Dir extends FSEntity {
  Stream<FSEntity> list({
    bool recursive = false,
    void Function(Exception e, FSEntity fse)? onException,
  });
}
