import 'package:sff_lib/function.dart';

abstract interface class IFunctionConfig {
  String get name;
  String get io;
  IFunction build();
}
