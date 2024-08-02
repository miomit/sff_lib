import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class VirtualFilesystemService implements IFilesystemService {
  final VirtualDirService? root = null;

  @override
  Result<IFilesystemEntityService, IOError> find(path) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  // TODO: implement rootPath
  String get rootPath => throw UnimplementedError();
}
