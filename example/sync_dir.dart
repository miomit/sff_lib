import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/function.dart';

void main() {
  Disk.io.mount(r"H:\", Native(r"/home/yura"));
  Disk.io.mount(r"E:\", Native(r"/media/yura/Elements"));
  syncDir(
    Dir(r"H:\Music"),
    Dir(r"E:\Music"),
  ).listen(print);
}
