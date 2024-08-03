import "package:option_result/result.dart";
import "package:sff_lib/errors.dart";
import "package:sff_lib/services.dart";

abstract interface class IFilesystemService {
  String get rootPath;
  Result<IFilesystemEntityService, IOError> find(path);

  Result<IFilesystemEntityService, IOError> mkdir(path);
  Result<IFilesystemEntityService, IOError> touch(path);
}
