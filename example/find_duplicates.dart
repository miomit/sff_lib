import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sff_lib/sff_lib.dart';

void main() {
  findDuplicates(
    [
      Directory('C:\\Users\\user_\\Изображения'),
      Directory('C:\\Users\\user_\\Документы')
    ],
    file: File("C:\\Users\\user_\\Изображения\\Ава\\1257855.jpg"),
    filter: (path) => p.extension(path) == ".jpg",
  ).listen(print);
}
