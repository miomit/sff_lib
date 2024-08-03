import 'package:option_result/result.dart';
import 'package:path/path.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class DiskService implements IDiskService, IIOService {
  final Map<String, IFilesystemService> _disks = {};

  @override
  List<String> getAllTarget() => _disks.keys.toList();

  @override
  Result<(), IOError> mount(IFilesystemService fs) {
    if (_disks[fs.rootPath] == null) {
      _disks[fs.rootPath] = fs;
      return fs.connect(this);
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
  Result<IFilesystemEntityService, IOError> create(
    String path,
    FilesystemEntityTypeService type,
  ) {
    if (_disks[rootPrefix(path)] case IFilesystemService fs) {
      return switch (type) {
        FilesystemEntityTypeService.dir => fs.mkdir(path),
        FilesystemEntityTypeService.file => fs.touch(path),
      };
    }

    return Err(IOError.doesNotExist);
  }

  @override
  Result<(), IOError> umount(String target) {
    if (_disks["$target:\\"] case IFilesystemService fs) {
      fs.disconnect();
      _disks.remove("$target:\\");
      return Ok(());
    }

    return Err(IOError.doesNotExist);
  }

  @override
  Result<IFilesystemEntityService, IOError> copy(
    String pathIn,
    String pathOut,
  ) {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
