import 'dart:collection';

import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../models/point_model.dart';

class PointProvider with ChangeNotifier {
  List<Point> _point = [];

  UnmodifiableListView get point {
    return UnmodifiableListView(_point);
  }

  //ambil data kamus dan masukkan ke _kamus
  Future<void> fetchAndSetPoint() async {
    final dataList = await DBHelper.instance.getPoint();
    _point = dataList
        .map((poin) => Point.withId(
              id: poin['id'],
              nama: poin['nama'],
              poin: poin['poin'],
              ttl_reward: poin['ttl_reward'],
            ))
        .toList();
    notifyListeners();
  }

  get mypoint {
    return _point[0].poin;
  }

  get mytotal {
    return _point[0].ttl_reward;
  }

  // //add akun poin
  // void addPoin(String nama, int poin, int total_reward) {
  //   final newPoin = Point(nama: nama, poin: poin, ttl_reward: total_reward);
  //   DBHelper.instance.insertPoint(newPoin);
  //   notifyListeners();
  // }

  //updatePoin
  void updatePoin(int poin, int ttl_reward) {
    final pointUser = _point[0];
    pointUser.poin = pointUser.poin! + poin;
    pointUser.ttl_reward = pointUser.ttl_reward! + ttl_reward;
    DBHelper.instance.updatePoint(pointUser);
    notifyListeners();
  }
}
