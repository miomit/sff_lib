import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

abstract interface class IIOService {
  Result<IFilesystemEntityService, IOError> open(String path);

  Result<IFilesystemEntityService, IOError> create(
    String path,
    FilesystemEntityTypeService type,
  );

  Result<IFilesystemEntityService, IOError> copy(
    String pathIn,
    String pathOut,
  );
}
