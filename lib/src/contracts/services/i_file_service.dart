import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

/// Additional features [IFilesystemEntityService] for interactions with files.
abstract interface class IFileService implements IFilesystemEntityService {
  /// Trying to open a [Stream] to read data, otherwise returns error [IOError].
  Result<Stream<List<int>>, IOError> openRead();

  /// Copies this file.
  Future<Result<IFileService, IOError>> copy(String newPath);

  /// Synchronously copies this file.
  Result<IFileService, IOError> copySync(String newPath);
}
