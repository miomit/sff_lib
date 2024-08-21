import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/src/contract/config/ifilesystem_config.dart';

class NativeConfig implements IFileSystemConfig {
  final String path;

  NativeConfig(this.path);

  @override
  String get name => "Native";

  @override
  IFileSystem build() => Native(path);
}
