import 'package:sff_lib/services.dart';

typedef Dir = VirtualDirService;
typedef File = VirtualFileService;

void main() {
  final disk = DiskService();

  disk.mount(
    VirtualFilesystemService(
      "C",
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
    ),
  );

  disk.copy("C:\\home\\_user\\Documents\\git.doc", "C:\\tmp");

  (disk.open("C:\\").unwrap() as IDirService)
      .list(recursive: true)
      .listen((vsf) => print(vsf.path));

  disk.umount("C");
}
