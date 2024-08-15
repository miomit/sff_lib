import 'package:path/path.dart' as p;
import 'package:sff_lib/filesystem.dart';

class FileStat extends Stat {
  DateTime changed;

  String get extension => p.extension(path);

  FileType? get fileType => FileType.getType(extension);

  FileStat({
    required super.path,
    required super.type,
    required super.size,
    required super.created,
    required this.changed,
    super.relativePath,
  });
}

class DirStat extends Stat {
  Future<int> count;

  DirStat({
    required super.path,
    required super.type,
    required super.size,
    required super.created,
    required this.count,
    super.relativePath,
  });
}

class Stat {
  String path;
  String? relativePath;
  EntityType type;

  DateTime created;

  int size;

  String get name => p.basename(path);

  Stat({
    required this.path,
    required this.type,
    required this.size,
    required this.created,
    this.relativePath,
  });
}
