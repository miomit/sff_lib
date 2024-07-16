import 'dart:io';

import 'package:sff_lib/sff_lib.dart';
import 'package:sff_lib/src/file_details.dart';

void main() {
  findDuplicates(
    [
      Directory('C:\\Users\\user_\\Изображения'),
      Directory('C:\\Users\\user_\\Документы')
    ],
    fileDet: FileDetails(
      path: "C:\\Users\\user_\\Изображения\\Ава\\1257855.jpg",
    ),
    filter: (fd) => fd.extension == ".jpg",
  ).listen(print);
}
