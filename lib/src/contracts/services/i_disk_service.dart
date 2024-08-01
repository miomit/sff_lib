import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/errors.dart';

abstract interface class IDiskService {
  Result<(), IOError> mount(IFilesystemService fs);
  Result<(), IOError> uount(String target);

  List<String> getAllTarget();

  Result<IFilesystemEntityService, IOError> open(String path);
}