
// //column for whistlist tabel
//   String table2 = 'whistlist';
//   String colId2 = 'id';
//   String colNama2 = 'nama';
//   String colTotal2 = 'total';
//   String colTanggal2 = 'tanggal';
//   String colIsComplete = 'isComplete';
//   String colCurrentDana = 'currentDana';

class WhistList {
  int? id;
  String? nama;
  double? total;
  String? tanggal;
  int? isComplete;
  double? currentDana;

  WhistList({
    this.nama = "DEFAULT NAME",
    this.total = 0,
    this.tanggal = "00:00:00",
    this.isComplete = 0,
    this.currentDana = 0,
  });

  WhistList.withId({
    required this.id,
    required this.nama,
    required this.total,
    required this.tanggal,
    required this.isComplete,
    required this.currentDana
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['nama'] = nama;
    map['total'] = total;
    map['tanggal'] = tanggal;
    map['isComplete'] = isComplete;
    map['currentDana'] = currentDana;
    return map;
  }

  factory WhistList.fromMap(Map<String, dynamic> map) {
    return WhistList.withId(
      id: map['id'],
      nama: map['nama'],
      total: map['total'],
      tanggal: map['tanggal'],
      isComplete: map['isComplete'],
      currentDana: map['currentDana'],
    );
  }
}
