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

  @override
  Result<IFilesystemEntityService, IOError> copy(
    IFilesystemEntityService entityIn,
    IDirService dirOut,
  ) {
    Result<IFilesystemEntityService, IOError> entity =
        Err(IOError.unsupportedFormat);

    if (dirOut case VirtualDirService dir) {
      if (entityIn case VirtualFileService file) {
        entity = Ok(VirtualFileService.clone(file));
      } else if (entityIn case VirtualDirService dir) {
        entity = Ok(VirtualDirService.clone(dir));
      }

      if (entity.andThen(dir.addChild) case Err(value: IOError ioErr)) {
        entity = Err(ioErr);
      }
    }

    return entity;
  }

  @override
  Result<(), IOError> delete(String path) {
    if (equals(path, rootPath)) {
      return Err(IOError.lowPermission);
    }

    return find(path).andThen((ent) {
      final parentDir = ent.parent as VirtualDirService;

      if (ent case VirtualDirService dir) {
        dir.reset();
      } else if (ent case VirtualFileService file) {
        file.reset();
      } else {
        return Err(IOError.unsupportedFormat);
      }

      return parentDir.removeChild(ent);
    });
  }

  @override
  Result<IFilesystemEntityService, IOError> move(
    IFilesystemEntityService entityIn,
    IDirService dirOut,
  ) {
    Result<IFilesystemEntityService, IOError> entity =
        Err(IOError.unsupportedFormat);

    if (entityIn.parent case VirtualDirService dirParent) {
      if (dirOut case VirtualDirService dir) {
        if (entityIn case VirtualFileService file) {
          file.reset();
          entity = Ok(file);
        } else if (entityIn case VirtualDirService dir) {
          //dir.reset();
          entity = Ok(dir);
        }

        if (entity.andThen(dir.addChild) case Err(value: IOError ioErr)) {
          entity = Err(ioErr);
        } else {
          dirParent.removeChild(entity.unwrap());
        }
      }
    }

    return entity;
  }
}
