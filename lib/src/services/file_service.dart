import 'package:sff_lib/services.dart';

class FileService extends FilesystemEntityService {
  FileService(super.path);

  FileService copy(String newPath) {
    return fs.copy(path, newPath);
  }

  FileService create({bool recursive = false}) {
    return fs.touch(path, recursive: recursive);
  }

  bool delete({bool recursive = false}) {
    return fs.delete(path, recursive: recursive);
  }

  Stream<List<int>> openRead() async* {
    yield* fs.openRead(path);
  }
}
