import 'package:test/test.dart';
import 'package:sff_lib/services.dart';

void main() {
  group('Filesystem', () {
    DiskService disk;

    setUp(() {
      disk = DiskService();
      disk.mount(VirtualFilesystemService());
    });
  });
}
