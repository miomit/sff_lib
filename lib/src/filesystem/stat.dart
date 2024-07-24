enum FSType { file, dir }

class Stat {
  final String name;
  final int size;
  final FSType type;

  Stat({
    required this.name,
    required this.size,
    required this.type,
  });
}
