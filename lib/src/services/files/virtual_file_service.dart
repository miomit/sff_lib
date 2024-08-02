import 'package:option_result/option.dart';
import 'package:sff_lib/services.dart';

class VirtualFileService implements IFileService, IStatFileService {
  @override
  void delete(String folderPath, String fileName) {
    // TODO: implement delete
  }

  @override
  read(String folderPath, String fileName) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  void save(String folderPath, String fileName, content) {
    // TODO: implement save
  }

  @override
  // TODO: implement changed
  DateTime get changed => throw UnimplementedError();

  @override
  // TODO: implement created
  DateTime get created => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement realPath
  Option<String> get realPath => throw UnimplementedError();

  @override
  // TODO: implement size
  int get size => throw UnimplementedError();
}
