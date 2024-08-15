import 'package:sff_lib/filesystem.dart';

/// Mechanism for working with file system.
abstract interface class IFileSystem {
  /// Method for connecting the file system.
  void connect();

  /// Method for disconnecting the file system.
  void disconnect();

  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  });

  /// Deletes this [Entity]
  void delete(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  });

  bool exists(
    String path, {
    EntityType type = EntityType.file,
  });

  /// Copies a file.
  Entity copy(String filePath, String dirPath);

  /// Moves a file or directory.
  Entity move(
    String pathIn,
    String pathOut, {
    EntityType type = EntityType.file,
  });

  /// Returns [Stat] for [Entity].
  Stat stat(
    String path, {
    EntityType type = EntityType.file,
  });

  Stream<Entity> list(String dirPath);

  Stream<List<int>> openRead(String filePath);
}
