import 'package:sff_lib/filesystem.dart';
import 'package:test/test.dart';

void main() {
  group('Disk', () {
    test("getFileSystemAndRelativePathByPath", () {
      var disk = Disk();

      final path1 = r"C:\";
      final path2 = r"C:\user_\";
      final path3 = r"C:\Users\user_\OneDrive\Рабочий стол\sff_lib";

      final (fs, rPath) = disk.getFileSystemAndRelativePathByPath(path1);
      expect(fs, equals(null));
      expect(rPath, equals(null));
    });
  });

  group('Virtual', () {});

  group('Native', () {});

  group('Entity', () {});

  group('Dir', () {});

  group('File', () {});
}
