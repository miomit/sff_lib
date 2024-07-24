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

  @override
  Stream<List<int>> openRead() async* {
    for (var i = 0; i < _data.length; i += 250) {
      yield _data.sublist(i, i + 250);
    }
  }
}
