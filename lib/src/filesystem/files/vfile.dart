part of '../virtual.dart';

class VFile extends File {
  String _name;
  final List<int> _data;

  VFile({
    required String name,
    List<int>? data,
  })  : _name = name,
        _data = data ?? [];

  @override
  String get name => _name;

  @override
  Future<Stat> get stat => Future.value(statSync);

  @override
  Stat get statSync {
    return Stat(
      name: name,
      size: _data.length,
      type: FSType.file,
    );
  }
}
