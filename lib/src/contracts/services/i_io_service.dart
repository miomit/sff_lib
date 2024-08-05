import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

/// Intermediate bridge between [IDiskService] and [IFilesystemService].
abstract interface class IIOService {
  /// Returns a directory or file by its existence.
  Result<IFilesystemEntityService, IOError> open(String path);

  /// Creates an empty file or directory.
  Result<IFilesystemEntityService, IOError> create(
    String path,
    FilesystemEntityTypeService type,
  );

  /// Copies a file or directory.
  Result<IFilesystemEntityService, IOError> copy(
    String pathEntityIn,
    String pathDirOut,
  );
}
