import 'package:option_result/result.dart';
import 'package:path/path.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class DiskService implements IDiskService {
  final Map<String, IFilesystemService> _disks = {};

  @override
  List<String> getAllTarget() => _disks.keys.toList();

  @override
  Result<(), IOError> mount(IFilesystemService fs) {
    if (_disks[fs.rootPath] == null) {
      _disks[fs.rootPath] = fs;
      return Ok(());
    }

    return Err(IOError.dirExist);
  }

  @override
  Result<IFilesystemEntityService, IOError> open(String path) {
    if (_disks[rootPrefix(path)] case IFilesystemService fs) {
      return fs.find(path);
    }

    return Err(IOError.doesNotExist);
  }

  @override
  Result<(), IOError> uount(String target) {
    if (_disks[target] case IFilesystemService fs) {
      _disks.remove(fs);
      return Ok(());
    }

    return Err(IOError.doesNotExist);
  }
  
}