import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

/// Mechanism to set up a link to [IFilesystemService].
class DiskService {
  static final Map<String, IFilesystemService> _disks = {};

  /// Return the name of all connected [IFilesystemService].
  static List<String> getAllTarget() => _disks.keys.toList();

  /// Establishing a connection to [IFilesystemService], otherwise returns error [IOError].
  static Result<(), IOError> mount(IFilesystemService fs) {
    if (_disks[fs.rootPath] == null) {
      _disks[fs.rootPath] = fs;
      return fs.connect();
    }

    return Err(IOError.dirExist);
  }

  /// Disables connection to [IFilesystemService], otherwise returns error [IOError].
  Result<(), IOError> umount(String target) {
    if (_disks["$target:\\"] case IFilesystemService fs) {
      fs.disconnect();
      _disks.remove("$target:\\");
      return Ok(());
    }

    return Err(IOError.doesNotExist);
  }
}
