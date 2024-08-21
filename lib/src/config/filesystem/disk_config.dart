import 'package:sff_lib/src/contract/config/ifilesystem_config.dart';

class DiskConfig {
  final String name;
  final Map<String, IFileSystemConfig> fsConfig = {};

  DiskConfig(this.name);
}
