import "package:option_result/result.dart";
import "package:sff_lib/errors.dart";
import "package:sff_lib/services.dart";

/// Mechanism for working with file system.
abstract interface class IFilesystemService {
  /// Virtual path root directory path or disk name.
  String get rootPath;

  /// Method for connecting the file system, otherwise returns error [IOError].
  Result<(), IOError> connect(IIOService io);

  /// Method for disconnecting the file system, otherwise returns error [IOError].
  Result<(), IOError> disconnect();

  /// Returns [IFilesystemEntityService] on his path, otherwise returns error [IOError].
  Result<IFilesystemEntityService, IOError> find(path);

  /// On the specified path Creates an empty directory, otherwise returns error [IOError].
  Result<IFilesystemEntityService, IOError> mkdir(path);

  /// On the specified path Creates an empty file, otherwise returns error [IOError].
  Result<IFilesystemEntityService, IOError> touch(path);
}
