import 'package:test/test.dart';
import 'package:sff_lib/services.dart';

typedef Dir = VirtualDirService;
typedef File = VirtualFileService;

void main() {
  group('Filesystem', () {
    DiskService disk = DiskService();

    test("Mount and umount", () {
      expect(disk.mount(newTestFS()).isOk(), equals(true));
      expect(disk.umount("A").isOk(), equals(true));
    });

    test('Open file and dir', () {
      expect(disk.mount(newTestFS()).isOk(), equals(true));

      expect(disk.open("A").isErr(), equals(true));
      expect(disk.open("A:\\").isOk(), equals(true));
      expect(disk.open("a:\\").isErr(), equals(true));
      expect(disk.open("A:\\home\\").isOk(), equals(true));
      expect(disk.open("A:\\home").isOk(), equals(true));

      expect(
        disk.open("A:\\home\\_user\\Documents\\sff.yaml\\").isOk(),
        equals(true),
      );

      expect(
        disk
            .open("A:\\home\\_user\\Documents\\sff.yaml")
            .isOkAnd((entity) => entity is IFileService),
        equals(true),
      );

      expect(
        disk
            .open("A:\\home\\_user\\Documents\\sff.yaml")
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

      disk.umount("A");
    });

    test('Equal', () {
      expect(disk.mount(newTestFS()).isOk(), equals(true));
      expect(disk.mount(newTestFS(name: "B")).isOk(), equals(true));

      final hashA = disk.open("A:\\").unwrap().hash;
      final hashB = disk.open("B:\\").unwrap().hash;

      expect(hashA == hashB, equals(true));

      expect(disk.umount("A").isOk(), equals(true));
      expect(disk.umount("B").isOk(), equals(true));
    });

    test('Not equal', () {
      expect(disk.mount(newTestFS(mntUsb: false)).isOk(), equals(true));
      expect(disk.mount(newTestFS(name: "B")).isOk(), equals(true));

      final hashA = disk.open("A:\\").unwrap().hash;
      final hashB = disk.open("B:\\").unwrap().hash;

      expect(hashA != hashB, equals(true));

      expect(disk.umount("A").isOk(), equals(true));
      expect(disk.umount("B").isOk(), equals(true));
    });

    test('Delete file', () {
      expect(disk.mount(newTestFS()).isOk(), equals(true));

      expect(
        disk.delete("A:\\home\\_user\\Documents\\pdf\\file1.pdf").isOk(),
        equals(true),
      );
      expect(
        disk.delete("A:\\home\\_user\\Documents\\doc\\file1.doc").isOk(),
        equals(true),
      );
      expect(
        disk.delete("A:\\home\\_user\\Documents\\sff.yaml").isOk(),
        equals(true),
      );
      expect(
        disk.delete("A:\\mnt\\usb 16G\\usb-file1.txt").isOk(),
        equals(true),
      );
      expect(
        disk.delete("A:\\mnt\\usb 16G\\usb-img.png").isOk(),
        equals(true),
      );

      expect(
        disk.delete("A:\\home\\miomit\\Documents\\pdf\\file1.pdf").isErr(),
        equals(true),
      );

      expect(
        disk.delete("A:\\home\\_user\\Documents\\pdf\\file1.pdf").isErr(),
        equals(true),
      );
      expect(
        disk.delete("A:\\home\\_user\\Documents\\doc\\file1.doc").isErr(),
        equals(true),
      );
      expect(
        disk.delete("A:\\home\\_user\\Documents\\sff.yaml").isErr(),
        equals(true),
      );
      expect(
        disk.delete("A:\\mnt\\usb 16G\\usb-file1.txt").isErr(),
        equals(true),
      );
      expect(
        disk.delete("A:\\mnt\\usb 16G\\usb-img.png").isErr(),
        equals(true),
      );

      expect(disk.umount("A").isOk(), equals(true));
    });

    test('Delete dir', () {
      expect(disk.mount(newTestFS(mntUsb: false)).isOk(), equals(true));
      expect(disk.mount(newTestFS(name: "B")).isOk(), equals(true));

      expect(disk.delete("B:\\mnt\\usb 16G").isOk(), equals(true));

      final hashA = disk.open("A:\\").unwrap().hash;
      final hashB = disk.open("B:\\").unwrap().hash;

      expect(hashA == hashB, equals(true));

      expect(disk.umount("A").isOk(), equals(true));
      expect(disk.umount("B").isOk(), equals(true));
    });

    test('Create dir and file', () {
      expect(disk.mount(newTestFS(mntUsb: false)).isOk(), equals(true));
      expect(disk.mount(newTestFS(name: "B")).isOk(), equals(true));

      expect(
        disk
            .create(
              "A:\\mnt\\usb 16G",
              FilesystemEntityTypeService.dir,
            )
            .isOk(),
        equals(true),
      );

      expect(
        disk
            .create(
              "A:\\mnt\\usb 16G\\usb-file1.txt",
              FilesystemEntityTypeService.file,
            )
            .isOk(),
        equals(true),
      );

      expect(
        disk
            .create(
              "A:\\mnt\\usb 16G\\usb-img.png",
              FilesystemEntityTypeService.file,
            )
            .isOk(),
        equals(true),
      );

      final hashA = disk.open("A:\\").unwrap().hash;
      final hashB = disk.open("B:\\").unwrap().hash;

      expect(hashA == hashB, equals(true));

      expect(disk.umount("A").isOk(), equals(true));
      expect(disk.umount("B").isOk(), equals(true));
    });
  });
}

/// newTestFS
/// A>
///  \
///   | mnt>
///        \
///         | usb 16G>
///                  \
///                   | usb-file1.txt
///                   | usb-img.png
///   | tmp>
///   | home>
///         \
///          | _user>
///                 \
///                  | Documents>
///                              \
///                               | pdf>
///                                     \
///                                      | file1.pdf
///                                      | ...
///                               | doc>
///                                     \
///                                      | file1.doc
///                                      | ...
///                               | sff.yaml
///                  | Videos>
///                           \
///                            | video.mp3
///                  | Pictures>
///                             \
///                              | img1.png
///                              | ...
IFilesystemService newTestFS({String name = "A", bool mntUsb = true}) {
  return VirtualFilesystemService(
    name,
    children: [
      Dir(
        "mnt",
        children: [
          if (mntUsb)
            Dir(
              "usb 16G",
              children: [
                File("usb-file1.txt"),
                File("usb-img.png"),
              ],
            )
        ],
      ),
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
                  Dir(
                    "pdf",
                    children: [
                      for (int i = 0; i < 10; i++) File("file$i.pdf"),
                    ],
                  ),
                  Dir(
                    "doc",
                    children: [
                      for (int i = 0; i < 5; i++) File("file$i.doc"),
                    ],
                  ),
                  File("sff.yaml"),
                ],
              ),
              Dir(
                "Videos",
                children: [
                  File("video.mp3"),
                ],
              ),
              Dir(
                "Pictures",
                children: [
                  for (int i = 0; i < 30; i++) File("img$i.png"),
                ],
              ),
            ],
          )
        ],
      ),
    ],
  );
}
