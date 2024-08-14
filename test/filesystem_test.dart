import 'package:sff_lib/filesystem.dart';
import 'package:test/test.dart';

void main() {
  group('Disk', () {
    group('getFileSystemAndRelativePathByPath', () {
      group('Without fs', () {
        test(r"'' -> (null, null)", () {});

        test(r"F:\ -> (null, '\')", () {});

        test(r"F:\user_ -> (null, '\user_')", () {});

        test(r"F:\user_\ -> (null, '\user_')", () {});

        test(r"USB:\img\info.png -> (null, '\img\info.png')", () {});
      });
    });
  });

  group('Virtual', () {});

  group('Native', () {});

  group('Entity', () {});

  group('Dir', () {});

  group('File', () {});
}
