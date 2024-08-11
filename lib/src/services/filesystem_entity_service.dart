import 'package:path/path.dart';
import 'package:sff_lib/services.dart';

/// Common interface between [IDirServicee] and [IFileService].
class FilesystemEntityService {
  /// The parent directory of this entity.
  DirService get parent => DirService(dirname(path));

  String get name => basename(path);

  final String path;
  final String target;

  /// File system of the current entity.
  IFilesystemService get fs {
    final fs = DiskService.getFilesystemByTarget(target);
    if (fs == null) throw "File system is not mounted";
    return fs;
  }

  FilesystemEntityService(this.path) : target = rootPrefix(path);

  /// Checks whether the file system entity with this path exists.
  Future<bool> exists() => Future.value(existsSync());

  /// Synchronously checks whether the file system entity with this path exists.
  bool existsSync() => fs.open(path) != null ? true : false;

  /// Returns meta data of this entity.
  StatService stat() => fs.stat(path);

  /// Renames this file system entity.
  ///
  /// Returns a [FilesystemEntityService] instance for the renamed entity.
  /// If `newPath` identifies an existing entity of the same type, that entity is removed first.
  FilesystemEntityService rename(String newPath) => fs.move(path, newPath);
}
