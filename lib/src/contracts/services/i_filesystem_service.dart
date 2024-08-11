import "package:sff_lib/services.dart";

/// Mechanism for working with file system.
abstract interface class IFilesystemService {
  /// Virtual path root directory path or disk name.
  String get rootPath;

  /// Method for connecting the file system.
  bool connect();

  /// Method for disconnecting the file system.
  bool disconnect();

  /// Deletes this [FilesystemEntityService]
  bool delete(String path);

  /// Returns [FilesystemEntityService] on his path.
  FilesystemEntityService? open(String path);

  /// Copies a file or directory.
  FilesystemEntityService copy(String pathIn, String pathOut);

  /// Moves a file or directory.
  FilesystemEntityService move(String pathIn, String pathOut);

  /// Returns [StatService] for [FilesystemEntityService].
  StatService stat(String path);

  Stream<FilesystemEntityService> list(String path);

  FilesystemEntityTypeService getType(String path);
}
