import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';

class Entity {
  String path;

  Dir get parent => Dir(dirname(path));

  final Disk io;
  final EntityType type;

  Entity(this.path, {required this.type, Disk? io}) : io = io ?? Disk.io;

  void delete({bool recursive = false}) {
    io.delete(path, recursive: recursive);
  }

  bool exists() {
    return io.exists(path, type: type);
  }

  void rename(String newName) {
    io.move(path, join(dirname(path), newName));
  }

  Stat stat() => io.stat(path);
}
