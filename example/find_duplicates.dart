import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/function.dart';

void main() {
  Disk.io.mount(r"U:\", Native(r"C:\Users\user_"));
  findDuplicates(
    [
      Dir(r'U:\Изображения'),
      Dir(r'U:\Документы'),
    ],
    file: File(r"C:\Изображения\Ава\1257855.jpg"),
    filter: (fd) => (fd.stat() as FileStat).fileType == FileType.picture,
  ).listen(print);
}
