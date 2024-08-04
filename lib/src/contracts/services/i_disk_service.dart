import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/errors.dart';

/// Mechanism to set up a link to [IFilesystemService].
abstract interface class IDiskService {
  /// Establishing a connection to [IFilesystemService], otherwise returns error [IOError].
  Result<(), IOError> mount(IFilesystemService fs);

  /// Disables connection to [IFilesystemService], otherwise returns error [IOError].
  Result<(), IOError> umount(String target);

  /// Return the name of all connected [IFilesystemService].
  List<String> getAllTarget();
}
