import 'dart:collection';

import 'package:dompet_q/models/habit_model.dart';
import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import 'package:intl/intl.dart';

class HabbitProvider with ChangeNotifier {
  //list of model habbit
  List<Habbit> _habbit = [];

  //getter list habbit
  UnmodifiableListView get habbit {
    return UnmodifiableListView(_habbit);
  }

  int get uncheckedHabbit {
    // return _habbit
    //     .where((element) =>
    //         DateTime.parse(element.updatedAt!).isAtSameMomentAs(DateTime.now()))
    //     .length;
    return _habbit
        .where(
          (element) =>
              DateFormat.yMd().format(DateTime.parse(element.updatedAt!)) !=
              DateFormat.yMd().format(
                DateTime.now(),
              ),
        )
        .length;
  }

  Future<void> fetchAndSetHabbit() async {
    final datalist = await DBHelper.instance.getHabitList();
    _habbit = datalist
        .map(
          (hbt) => Habbit.withId(
            id: hbt['id'],
            nama: hbt['nama'],
            repetisi: hbt['repetisi'],
            tanggal: hbt['tanggal'],
            updatedAt: hbt['updatedAt'],
            poinGain: hbt['poinGain']
          ),
        )
        .toList();
    notifyListeners();
  }

  void addHabbit(String nama, String tanggal,int poin) {
    final newHabbit = new Habbit(
      nama: nama,
      tanggal: tanggal,
      repetisi: 0,
      updatedAt: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      poinGain: poin
      // updatedAt: DateTime.now().toIso8601String(),
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
  void updateHabbit(int id, String nama, int status,int poin) {
    final selectedHabbit =
        _habbit[_habbit.indexWhere((element) => element.id == id)];
    // selectedHabbit.repetisi = selectedHabbit.repetisi! + 1;

    final dataBaru = new Habbit.withId(
      id: id,
      nama: nama,
      repetisi:
          status > 0 ? selectedHabbit.repetisi! + 1 : selectedHabbit.repetisi,
      tanggal: selectedHabbit.tanggal,
      updatedAt: DateTime.now().toIso8601String(),
      poinGain: poin
    );
    _habbit[_habbit.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updateHabbit(dataBaru);
    notifyListeners();
  }
}
