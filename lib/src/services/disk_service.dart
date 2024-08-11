import 'package:sff_lib/services.dart';

/// Mechanism to set up a link to [IFilesystemService].
class DiskService {
  static final Map<String, IFilesystemService> _disks = {};

  /// Return the [IFilesystemService] by target
  static IFilesystemService? getFilesystemByTarget(String target) {
    return _disks[target];
  }

  /// Return the name of all connected [IFilesystemService].
  static List<String> getAllTarget() {
    return _disks.keys.toList();
  }

  /// Establishing a connection to [IFilesystemService].
  static bool mount(IFilesystemService fs) {
    if (_disks[fs.rootPath] == null) {
      _disks[fs.rootPath] = fs;
      return fs.connect();
    }

    return false;
  }

  /// Disables connection to [IFilesystemService].
  bool umount(String target) {
    if (_disks[target] case IFilesystemService fs) {
      fs.disconnect();
      _disks.remove("$target:\\");
      return true;
    }

    return false;
  }
}
