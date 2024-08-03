import 'package:sff_lib/services.dart';

void main() {
  final disk = DiskService();

  disk.mount(VirtualFilesystemService("C"));

  disk.create("C:\\hello", FilesystemEntityTypeService.file);
  disk.create("C:\\hh", FilesystemEntityTypeService.file);

  disk.create("C:\\dir1", FilesystemEntityTypeService.dir);
  disk.create("C:\\dir2", FilesystemEntityTypeService.dir);

  disk.create("C:\\dir1\\f11", FilesystemEntityTypeService.file).unwrap();
  disk.create("C:\\dir1\\f12", FilesystemEntityTypeService.file);
  disk.create("C:\\dir1\\f13", FilesystemEntityTypeService.file);

  disk.create("C:\\dir2\\dir21", FilesystemEntityTypeService.dir);
  disk.create("C:\\dir2\\dir22", FilesystemEntityTypeService.dir);
  disk.create("C:\\dir2\\f23", FilesystemEntityTypeService.file);

  (disk.open("C:\\").unwrap() as IDirService)
      .list(recursive: true)
      .listen((vsf) => print(vsf.path));

  disk.umount("C");
}
