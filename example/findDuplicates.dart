import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sff_lib/sff_lib.dart';

void main() {
  findDuplicates(Directory('/home/yura/Изображения'), (path) {
    return p.extension(path) == ".png";
  }).listen((event) {
    print("\n------\n${event.$1}\n${event.$2}");
  });
}
