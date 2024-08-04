import 'package:option_result/option.dart';
import 'package:option_result/result.dart';
import 'package:path/path.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

/// Virtual file system for [DiskService].
class VirtualFilesystemService implements IFilesystemService {
  VirtualDirService root;

  VirtualFilesystemService(
    String name, {
    List<IFilesystemEntityService>? children,
  }) : root = VirtualDirService(name) {
    if (children != null) {
      root.addChildren(children);
    }
  }

  @override
  Result<IFilesystemEntityService, IOError> find(path) {
    IFilesystemEntityService? res;

    for (var name in split(path)) {
      if (name == rootPrefix(path)) {
        res = root;
      } else if (res case VirtualDirService dir) {
        if (dir.getChildByName(name).andThen(
          (fse) {
            res = fse;
            return Some(());
          },
        ).isNone()) {
          return Err(IOError.doesNotExist);
        }
      } else {
        return Err(IOError.doesNotExist);
      }
    }

    return res != null ? Ok(res!) : Err(IOError.doesNotExist);
  }

  @override
  String get rootPath => root.path;

  @override
  Result<IFilesystemEntityService, IOError> mkdir(path) {
    return find(dirname(path)).andThen((fse) {
      if (fse case VirtualDirService dir) {
        final newDir = VirtualDirService(basename(path));
        return dir.addChild(newDir).andThen((_) => Ok(newDir));
      } else if (fse is VirtualFileService) {
        return Err(IOError.fileExist);
      }
      return Err(IOError.unsupportedFormat);
    });
  }

  @override
  Result<IFilesystemEntityService, IOError> touch(path) {
    return find(dirname(path)).andThen((fse) {
      if (fse case VirtualDirService dir) {
        final newFile = VirtualFileService(basename(path));
        return dir.addChild(newFile).andThen((_) => Ok(newFile));
      } else if (fse is VirtualFileService) {
        return Err(IOError.fileExist);
      }
      return Err(IOError.unsupportedFormat);
    });
  }

  @override
  Result<(), IOError> connect(IIOService io) {
    root.io = io;
    return Ok(());
  }

  @override
  Result<(), IOError> disconnect() => Ok(());
}
