import 'package:test/test.dart';
import 'package:sff_lib/services.dart';

typedef Dir = VirtualDirService;
typedef File = VirtualFileService;

void main() {
  group('Filesystem', () {
    late DiskService disk;

    setUp(() {
      disk = DiskService();
      disk.mount(VirtualFilesystemService(
        "A",
        children: [
          Dir("mnt"),
          Dir("tmp"),
          Dir(
            "home",
            children: [
              Dir(
                "_user",
                children: [
                  Dir(
                    "Documents",
                    children: [
                      File("git.doc"),
                      File("info.doc"),
                    ],
                  ),
                  File("sff.yaml"),
                ],
              )
            ],
          ),
        ],
      ));
      disk.mount(VirtualFilesystemService(
        "B",
        children: [
          Dir("mnt"),
          Dir("tmp"),
          Dir(
            "home",
            children: [
              Dir(
                "_user",
                children: [
                  Dir(
                    "Documents",
                    children: [
                      File("git.doc"),
                      File("info.doc"),
                    ],
                  ),
                  File("sff.yaml"),
                ],
              )
            ],
          ),
        ],
      ));

      disk.mount(VirtualFilesystemService(
        "C",
        children: [
          Dir("mnt"),
          Dir("tmp"),
          Dir("home"),
        ],
      ));
    });

    test('Equal disk A and B', () {
      final hashA = disk.open("A:\\").unwrap().hash;
      final hashB = disk.open("B:\\").unwrap().hash;

      expect(hashA == hashB, equals(true));
    });

    test('Not equal disk B and C', () {
      final hashB = disk.open("B:\\").unwrap().hash;
      final hashC = disk.open("C:\\").unwrap().hash;

      expect(hashC != hashB, equals(true));
    });

    test('Delete file', () {
      final file = disk.open("A:\\home\\_user\\Documents\\info.doc").unwrap();

      expect(file.existsSync(), equals(true));

      disk.delete("A:\\home\\_user\\Documents\\info.doc");

      expect(file.existsSync(), equals(false));
    });

    test('Delete dir', () {
      final file = disk.open("A:\\home\\_user\\Documents\\git.doc").unwrap();
      final dir = disk.open("A:\\home\\_user\\Documents").unwrap();

      expect(file.existsSync(), equals(true));
      expect(dir.existsSync(), equals(true));

      disk.delete("A:\\home\\_user\\Documents");

      expect(file.existsSync(), equals(false));
      expect(dir.existsSync(), equals(false));
    });
  });
}
