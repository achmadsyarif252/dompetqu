import 'package:dompet_q/models/transaction.dart';

class Habbit {
  int? id;
  String? nama;
  int? repetisi;
  String? tanggal;
  String? updatedAt;
  int? poinGain;

  Habbit({
    this.nama = "DEFAULT",
    this.repetisi = 0,
    this.tanggal = "00:00:00",
    this.updatedAt = "00:00:00",
    this.poinGain=0
  });

  Habbit.withId({
    required this.id,
    required this.nama,
    required this.repetisi,
    required this.tanggal,
    required this.updatedAt,
    required this.poinGain
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (map['id'] != null) {
      map['id'] = id;
    }
    map['id'] = id;
    map['nama'] = nama;
    map['repetisi'] = repetisi;
    map['tanggal'] = tanggal;
    map['updatedAt'] = updatedAt;
    map['poinGain']=poinGain;

    return map;
  }

  factory Habbit.fromMap(Map<String, dynamic> map) {
    return Habbit.withId(
        id: map['id'],
        nama: map['nama'],
        repetisi: map['repetisi'],
        tanggal: map['tanggal'],
        updatedAt: map['updatedAt'],
        poinGain:map['poinGain']);
  }
}
