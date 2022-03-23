class Point {
  int? id;
  String? nama;
  int? poin;
  int? ttl_reward;

  Point({
    required this.nama,
    required this.poin,
    required this.ttl_reward,
  });

  Point.withId(
      {required this.id,
      required this.nama,
      required this.poin,
      required this.ttl_reward});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['nama'] = nama;
    map['poin'] = poin;
    map['ttl_reward'] = ttl_reward;
    return map;
  }

  factory Point.fromMap(Map<String, dynamic> map) {
    return Point.withId(
      id: map['id'],
      nama: map['nama'],
      poin: map['poin'],
      ttl_reward: map['ttl_reward'],
    );
  }
}
