class IdeApps {
  int? id;
  String? nama;
  String? detail;
  int? isDone;

  IdeApps({
    required this.nama,
    required this.detail,
    required this.isDone,
  });

  IdeApps.withId({
    required this.id,
    required this.nama,
    required this.detail,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['nama'] = nama;
    map['detail'] = detail;
    map['isDone'] = isDone;
    return map;
  }

  factory IdeApps.fromMap(Map<String, dynamic> map) {
    return IdeApps.withId(
      id: map['id'],
      nama: map['nama'],
      detail: map['detail'],
      isDone: map['isDone'],
    );
  }
}
