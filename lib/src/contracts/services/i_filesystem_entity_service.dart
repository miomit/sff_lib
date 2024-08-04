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
}
