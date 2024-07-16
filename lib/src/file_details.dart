import 'dart:io';
import 'package:path/path.dart' as p;

enum FileType {
  document,
  picture,
  music,
}

class FileDetails {
  final String path;

  final String name;
  final String extension;

  final String dirPath;

  final FileType? type;

  File get file => File(path);
  bool get isExist => file.existsSync();

  FileDetails({
    required this.path,
    this.type,
  })  : name = p.basenameWithoutExtension(path),
        extension = p.extension(path),
        dirPath = p.dirname(path);
}
