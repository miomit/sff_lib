import 'dart:io';
import 'package:path/path.dart' as p;

enum FileType {
  document,
  picture,
  vector,
  audio,
  video;

  static FileType? getType(String ext) => switch (ext) {
        '.jpeg' ||
        '.jpg' ||
        '.png' ||
        '.webp' ||
        '.gif' ||
        '.raw' ||
        '.tiff' ||
        '.psd' => //
          FileType.picture,
        '.svg' ||
        '.esp' ||
        '.pdf' ||
        '.ai' ||
        '.cdr' => //
          FileType.vector,
        '.avi' ||
        '.mkv' ||
        '.mp4' ||
        '.mpeg' ||
        '.ogv' ||
        '.webm' => //
          FileType.video,
        '.m4a' ||
        '.mp3' ||
        '.wav' ||
        '.ogg' ||
        '.mpa' ||
        '.flac' => //
          FileType.audio,
        '.pdf' ||
        '.djvy' ||
        '.doc' ||
        '.docx' ||
        '.txt' ||
        '.md' => //
          FileType.document,
        _ => null,
      };
}

class FileDetails {
  final String path;

  final String name;
  final String extension;

  final String dirPath;

  FileType? type;

  File get file => File(path);
  bool get isExist => file.existsSync();

  FileDetails({
    required this.path,
  })  : name = p.basenameWithoutExtension(path),
        extension = p.extension(path),
        dirPath = p.dirname(path) {
    type = FileType.getType(extension);
  }
}
