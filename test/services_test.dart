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

    test('Open file and dir', () {
      expect(disk.open("A").isErr(), equals(true));
      expect(disk.open("A:\\").isOk(), equals(true));
      expect(disk.open("a:\\").isErr(), equals(true));
      expect(disk.open("A:\\home\\").isOk(), equals(true));
      expect(disk.open("A:\\home").isOk(), equals(true));

      expect(disk.open("A:\\home\\_user\\sff.yaml\\").isOk(), equals(true));

      expect(
        disk
            .open("A:\\home\\_user\\sff.yaml")
            .isOkAnd((entity) => entity is IFileService),
        equals(true),
      );

      expect(
        disk
            .open("A:\\home\\_user\\sff.yaml")
            .isOkAnd((entity) => entity is IDirService),
        equals(false),
      );

      expect(
        disk.open("A:\\home\\_user").isOkAnd((entity) => entity is IDirService),
        equals(true),
      );

      expect(
        disk
            .open("A:\\home\\_user")
            .isOkAnd((entity) => entity is IFileService),
        equals(false),
      );
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

      disk.delete("A:\\home\\_user");

      final hashA = disk.open("A:\\").unwrap().hash;
      final hashC = disk.open("C:\\").unwrap().hash;

      expect(hashA == hashC, equals(true));
    });

    test('Create dir and file', () {
      expect(
        disk
            .create(
              "A:\\home\\miomit",
              FilesystemEntityTypeService.dir,
            )
            .isOk(),
        equals(true),
      );

      expect(
        disk
            .create(
              "A:\\home\\miomit\\sff.yaml",
              FilesystemEntityTypeService.file,
            )
            .isOk(),
        equals(true),
      );

      expect(
        disk
            .create(
              "A:\\err\\file",
              FilesystemEntityTypeService.file,
            )
            .isErr(),
        equals(true),
      );

      expect(
        disk
            .create(
              "H:\\file",
              FilesystemEntityTypeService.file,
            )
            .isErr(),
        equals(true),
      );

      expect(
        disk
            .create(
              "",
              FilesystemEntityTypeService.file,
            )
            .isErr(),
        equals(true),
      );
    });
  });
}
