import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

abstract interface class IFileService implements IFilesystemEntityService {
  Result<Stream<List<int>>, IOError> openRead();

  Future<Result<IFileService, IOError>> copy(String newPath);
  Result<IFileService, IOError> copySync(String newPath);
}
