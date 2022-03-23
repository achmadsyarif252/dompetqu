import 'dart:collection';

import 'package:dompet_q/models/kamus_model.dart';
import 'package:flutter/cupertino.dart';
import '../helper/db_helper.dart';

class KamusProvider with ChangeNotifier {
  List<Kamus> _kamus = [];
  UnmodifiableListView get kamus {
    return UnmodifiableListView(_kamus);
  }

  //ambil data kamus dan masukkan ke _kamus
  Future<void> fetchAndSetKamus() async {
    final dataList = await DBHelper.instance.getKamus();
    _kamus = dataList
        .map((kamus) => Kamus.withId(
              id: kamus['id'],
              kata: kamus['kata'],
              arti: kamus['arti'],
            ))
        .toList();
    notifyListeners();
  }

  //add kata baru
  void addKata(String kata, String arti) {
    final newKata = Kamus(kata: kata, arti: arti);
    DBHelper.instance.insertKata(newKata);
    notifyListeners();
  }

//updateKata
  void updateKata(int id, String kata, String arti) {
    final dataBaru = new Kamus.withId(
      id: id,
      kata: kata,
      arti: arti,
    );
    _kamus[_kamus.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updatekata(dataBaru);
    notifyListeners();
  }

  //deleteKata
  void delete(int id) async {
    await DBHelper.instance.deleteKata(id);
    notifyListeners();
  }

  get totalKamus {
    return _kamus.length;
  }
}
