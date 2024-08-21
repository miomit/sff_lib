import 'package:sff_lib/filesystem.dart';

abstract interface class IFileSystemConfig {
  String get name;
  IFileSystem build();
}
