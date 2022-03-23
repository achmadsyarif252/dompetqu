import 'dart:collection';

import 'package:dompet_q/models/counter.dart';
import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../models/point_model.dart';

class CounterProvider with ChangeNotifier {
  List<Counter> _counter = [];

  UnmodifiableListView get counter {
    return UnmodifiableListView(_counter);
  }

  //ambil data kamus dan masukkan ke _kamus
  Future<void> fetchAndSetCounter() async {
    final dataList = await DBHelper.instance.getCounter();
    _counter = dataList
        .map((poin) => Counter.withId(
            id: poin['id'], nama: poin['nama'], total: poin['total']))
        .toList();
    notifyListeners();
  }

 

  //add akun poin
  void addCounter(String nama) {
    final newCounter = Counter(nama: nama,total: 0);
    DBHelper.instance.insertCounter(newCounter);
    notifyListeners();
  }

  //updateKata
  void updatePoin(int id,String nama,int total) {
    final dataBaru = new Counter.withId(
      id: id,
      nama: nama,
      total: total+1
    );
    _counter[_counter.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updateCounter(dataBaru);
    notifyListeners();
  }
}
