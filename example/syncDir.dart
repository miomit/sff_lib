import 'dart:io';

import 'package:sff_lib/sff_lib.dart';

void main() {
  syncDir(
    Directory('/media/yura/Elements/Music'),
    Directory('/home/yura/Music')
  ).listen((event) {
    print("\n------\n${event.$1}\n${event.$2}");
  });
}
