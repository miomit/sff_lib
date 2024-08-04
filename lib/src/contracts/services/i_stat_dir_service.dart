import 'package:sff_lib/services.dart';

/// Additional meta data for directory.
abstract interface class IStatDirService implements IStatService {
  /// Number of files and directories.
  Future<int> get count;

  /// Number of files.
  Future<int> get fileCount;

  /// Number of directories.
  Future<int> get dirCount;
}
