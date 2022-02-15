import 'dart:collection';

import 'package:dompet_q/helper/db_helper.dart';
import 'package:dompet_q/models/ide_apps_model.dart';
import 'package:flutter/cupertino.dart';

class IdeAppsProvider with ChangeNotifier {
  List<IdeApps> _ideApps = [];
  UnmodifiableListView get ideApps {
    return UnmodifiableListView(_ideApps);
  }

  int compare(int a, int b) {
    if (a > 0) {
      return 0;
    }
    return 1;
  }

  Future<void> fetchAndSetIdeApps() async {
    final dataList = await DBHelper.instance.getIdeApps();
    _ideApps = dataList
        .map(
          (ide) => IdeApps.withId(
            id: ide['id'],
            nama: ide['nama'],
            detail: ide['detail'],
            isDone: ide['isDone'],
          ),
        )
        .toList();
    _ideApps.sort(
      (a, b) => a.isDone!.compareTo(b.isDone!),
    );
    notifyListeners();
  }

  void addIde(String nama, String detail) {
    final newIde = IdeApps(
      nama: nama,
      detail: detail,
      isDone: 0,
    );
    DBHelper.instance.inserIde(newIde);
    notifyListeners();
  }

  //update
  void updateIde(int id) {
    final selectedIde =
        _ideApps[_ideApps.indexWhere((element) => element.id == id)];
    // selectedHabbit.repetisi = selectedHabbit.repetisi! + 1;

    final dataBaru = new IdeApps.withId(
      id: id,
      nama: selectedIde.nama,
      detail: selectedIde.detail,
      isDone: selectedIde.isDone == 1 ? 0 : 1,
    );
    _ideApps[_ideApps.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updateIde(dataBaru);
    notifyListeners();
  }

  IdeApps findById(int id) {
    return _ideApps.firstWhere((element) => element.id == id);
  }

  void delete(int id) async {
    await DBHelper.instance.deleteIde(id);
    notifyListeners();
  }
}
