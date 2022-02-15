import 'dart:collection';

import 'package:dompet_q/helper/db_helper.dart';
import 'package:dompet_q/models/whistlist.dart';
import 'package:flutter/cupertino.dart';

class WhistListProvider with ChangeNotifier {
  List<WhistList> _whistList = [];

  UnmodifiableListView get whistList {
    return UnmodifiableListView(_whistList);
  }

  get totalItem {
    return _whistList.where((element) => element.isComplete == 1).length;
  }

  Future<void> fetchAndSetWhistListUnCheck() async {
    final dataList = await DBHelper.instance.getWhistList();
    _whistList = dataList
        .map((wL) => WhistList.withId(
              id: wL['id'],
              nama: wL['nama'],
              total: wL['total'],
              tanggal: wL['tanggal'],
              isComplete: wL['isComplete'],
              currentDana: wL['currentDana'],
            ))
        .where((element) => element.isComplete == 0)
        .toList();
    _whistList.where((item) => item.isComplete == 0);
    notifyListeners();
  }

  Future<void> fetchAndSetWhistListCheck() async {
    final dataList = await DBHelper.instance.getWhistList();
    _whistList = dataList
        .map((wL) => WhistList.withId(
              id: wL['id'],
              nama: wL['nama'],
              total: wL['total'],
              tanggal: wL['tanggal'],
              isComplete: wL['isComplete'],
              currentDana: wL['currentDana'],
            ))
        .where((element) => element.isComplete == 1)
        .toList();
    _whistList.where((item) => item.isComplete == 1);
    notifyListeners();
  }

  void addWhistList(String nama, double total, String tanggal) {
    final whistListBaru = new WhistList(
      nama: nama,
      total: total,
      tanggal: tanggal,
      isComplete: 0,
      currentDana: 0,
    );
    DBHelper.instance.insertWhistList(whistListBaru);
    notifyListeners();
  }

  void update(int id, String nama, double total, String tanggal, int isComplete,
      double currentDana) {
    final dataBaru = new WhistList.withId(
      id: id,
      nama: nama,
      total: total,
      tanggal: tanggal,
      isComplete: isComplete,
      currentDana: currentDana,
    );
    _whistList[_whistList.indexWhere((element) => element.id == id)] = dataBaru;
    notifyListeners();
    DBHelper.instance.updateStatus(dataBaru);
  }

  void delete(int id) async {
    await DBHelper.instance.deleteWhistList(id);
    notifyListeners();
  }

  WhistList findById(int id) {
    return _whistList.firstWhere((element) => element.id == id);
  }
}
