import 'package:sff_lib/filesystem.dart';

/// Mechanism for working with file system.
abstract interface class IFileSystem {
  /// Method for connecting the file system.
  bool connect();

  /// Method for disconnecting the file system.
  bool disconnect();

  /// Returns [Entity] on his path.
  Entity? open(String path);

  void create(Entity entity, {bool recursive = false});

  /// Deletes this [Entity]
  bool delete(String path, {bool recursive = false});

  /// Copies a file.
  Entity copy(String pathIn, String pathOut);

  /// Moves a file or directory.
  Entity move(String pathIn, String pathOut);

  /// Returns [Stat] for [Entity].
  Stat stat(String path);

  Stream<Entity> list(String path);

  Stream<int> openRead(String file);
}
