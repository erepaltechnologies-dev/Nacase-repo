class PracticeArea {
  final String name;
  final String? description;
  final String? icon;

  const PracticeArea({
    required this.name,
    this.description,
    this.icon,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PracticeArea && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

class PracticeAreas {
  static const List<PracticeArea> all = [
    PracticeArea(name: 'Criminal Litigation'),
    PracticeArea(name: 'Civil Litigation'),
    PracticeArea(name: 'Corporate Law & Practice'),
    PracticeArea(name: 'Property Law'),
    PracticeArea(name: 'Constitutional & Human Rights Law'),
    PracticeArea(name: 'Commercial & Financial Law'),
  ];

  static List<String> get names => all.map((area) => area.name).toList();

  static PracticeArea? findByName(String name) {
    try {
      return all.firstWhere((area) => area.name == name);
    } catch (e) {
      return null;
    }
  }

  static bool contains(String name) {
    return all.any((area) => area.name == name);
  }
}