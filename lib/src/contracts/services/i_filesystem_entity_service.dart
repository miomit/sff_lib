import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

/// Common interface between [IDirServicee] and [IFileService].
abstract interface class IFilesystemEntityService {
  /// The parent directory of this entity.
  IDirService get parent;

  String get path;

  /// Checks whether the file system entity with this path exists.
  Future<bool> exists();

  /// Synchronously checks whether the file system entity with this path exists.
  bool existsSync();

  /// Returns meta data of this entity.
  Future<IStatService> stat();

  /// Synchronously returns meta data of this entity.
  IStatService statSync();

  /// Renames this file system entity.
  ///
  /// Returns a [IFilesystemEntityService] instance for the renamed entity.
  /// If `newPath` identifies an existing entity of the same type, that entity is removed first.
  Future<IFilesystemEntityService> rename(String newPath);

  /// Synchronously renames this file system entity
  ///
  /// Returns a [IFilesystemEntityService] instance for the renamed entity.
  /// If `newPath` identifies an existing entity of the same type, that entity is removed first.
  IFilesystemEntityService renameSync(String newPath);
}
