enum Jenis {
  Pemasukan,
  Pengeluaran,
}


class Transaction {
  int? id;
  String? name;
  double? total;
  String? jenis;
  String? tanggal;

  Transaction({
    this.name = "DEFAULT NAME",
    this.total = 0,
    this.jenis = "1",
    this.tanggal = "00 00 00",
  });

  Transaction.withId({
    required this.id,
    required this.name,
    required this.total,
    required this.jenis,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['nama'] = name;
    map['total'] = total;
    map['tanggal'] = tanggal;
    map['jenis'] = jenis;
    return map;
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction.withId(
      id: map['id'],
      name: map['nama'],
      total: map['total'],
      tanggal: map['tanggal'],
      jenis: map['jenis'],
    );
  }
}
