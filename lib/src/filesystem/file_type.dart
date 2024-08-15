/// Enumeration to determine file type.
enum FileType {
  document,
  picture,
  vector,
  audio,
  video;

  /// Get type by extension,
  /// otherwise returns null.
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
