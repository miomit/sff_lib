import 'package:sff_lib/filesystem.dart';
import 'package:test/test.dart';

void main() {
  group('Disk', () {
    group('getFileSystemAndRelativePathByPath', () {
      group('Without fs', () {
        test(r"'' -> (null, null)", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"",
            ),
            equals((null, null)),
          );
        });

        test(r"'\' -> (null, null)", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"",
            ),
            equals((null, null)),
          );
        });

        test(r"'\path\to\file' -> (null, null)", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"",
            ),
            equals((null, null)),
          );
        });

        test(r"F:\ -> (null, '\')", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"F:\",
            ),
            equals((null, r'\')),
          );
        });

        test(r"F:\user_ -> (null, '\user_')", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"F:\user_",
            ),
            equals((null, r'\user_')),
          );
        });

        test(r"F:\user_\ -> (null, '\user_')", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"F:\user_\",
            ),
            equals((null, r'\user_')),
          );
        });

        test(r"U:\img\info.png -> (null, '\img\info.png')", () {
          expect(
            Disk.io.getFileSystemAndRelativePathByPath(
              r"U:\img\info.png",
            ),
            equals((null, r'\img\info.png')),
          );
        });
      });
    });
  });

  group('Virtual', () {});

  group('Native', () {});

  group('Entity', () {});

  group('Dir', () {});

  group('File', () {});
}
