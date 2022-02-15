import 'dart:collection';

import 'package:dompet_q/models/habit_model.dart';
import 'package:flutter/material.dart';
import '../helper/db_helper.dart';

class HabbitProvider with ChangeNotifier {
  //list of model habbit
  List<Habbit> _habbit = [];

  //getter list habbit
  UnmodifiableListView get habbit {
    return UnmodifiableListView(_habbit);
  }

  Future<void> fetchAndSetHabbit() async {
    final datalist = await DBHelper.instance.getHabitList();
    _habbit = datalist
        .map(
          (hbt) => Habbit.withId(
              id: hbt['id'],
              nama: hbt['nama'],
              repetisi: hbt['repetisi'],
              tanggal: hbt['tanggal']),
        )
        .toList();
    notifyListeners();
  }

  void addHabbit(String nama, String tanggal) {
    final newHabbit = new Habbit(
      nama: nama,
      tanggal: tanggal,
      repetisi: 0,
    );
    DBHelper.instance.insertHabbit(newHabbit);
    notifyListeners();
  }

  void delete(int id) async {
    await DBHelper.instance.deleteHabbit(id);
    notifyListeners();
  }

  Habbit findById(int id) {
    // return _habbit[_habbit.indexWhere((element) => element.id==id)];
    return _habbit.firstWhere((element) => element.id == id);
  }

  //update
  void updateHabbit(int id, String nama, int status) {
    final selectedHabbit =
        _habbit[_habbit.indexWhere((element) => element.id == id)];
    // selectedHabbit.repetisi = selectedHabbit.repetisi! + 1;

    final dataBaru = new Habbit.withId(
      id: id,
      nama: nama,
      repetisi:
          status > 0 ? selectedHabbit.repetisi! + 1 : selectedHabbit.repetisi,
      tanggal: selectedHabbit.tanggal,
    );
    _habbit[_habbit.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updateHabbit(dataBaru);
    notifyListeners();
  }
}
