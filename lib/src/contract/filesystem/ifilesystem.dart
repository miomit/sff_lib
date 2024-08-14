import 'package:sff_lib/filesystem.dart';

/// Mechanism for working with file system.
abstract interface class IFileSystem {
  /// Method for connecting the file system.
  void connect();

  /// Method for disconnecting the file system.
  void disconnect();

  /// Returns [Entity] on his path.
  Entity? open(String path);

  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  });

  /// Deletes this [Entity]
  bool delete(String path, {bool recursive = false});

  /// Copies a file.
  Entity copy(String filePath, String dirPath);

  /// Moves a file or directory.
  Entity move(String pathIn, String pathOut);

  /// Returns [Stat] for [Entity].
  Stat stat(String path);

  Stream<Entity> list(String dirPath);

  Stream<int> openRead(String filePath);
}