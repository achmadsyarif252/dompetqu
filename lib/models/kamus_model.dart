class Kamus {
  int? id;
  String? kata;
  String? arti;

  Kamus({
    required this.kata,
    required this.arti,
  });

  Kamus.withId({
    required this.id,
    required this.kata,
    required this.arti,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['kata'] = kata;
    map['arti'] = arti;
    return map;
  }

  factory Kamus.fromMap(Map<String, dynamic> map) {
    return Kamus.withId(
      id: map['id'],
      kata: map['kata'],
      arti: map['arti'],
    );
  }
}
