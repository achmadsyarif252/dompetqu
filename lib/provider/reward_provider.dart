import 'dart:collection';

import 'package:dompet_q/models/reward_model.dart';
import 'package:flutter/material.dart';

import '../helper/db_helper.dart';

class RewardProvider with ChangeNotifier {
  List<Reward> _reward = [];

  UnmodifiableListView get reward {
    return UnmodifiableListView(_reward);
  }

  //ambil data reward dan masukkan ke _reward
  Future<void> fetchAndSetReward() async {
    final dataList = await DBHelper.instance.getReward();
    _reward = dataList
        .map((reward) => Reward.withId(
              id: reward['id'],
              nama: reward['nama'],
              req_poin: reward['req_poin'],
              completed: reward['completed'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetRewardByPoint(int poin) async {
    final dataList = await DBHelper.instance.getReward();
    _reward = dataList
        .map((reward) => Reward.withId(
              id: reward['id'],
              nama: reward['nama'],
              req_poin: reward['req_poin'],
              completed: reward['completed'],
            ))
        .toList();
    notifyListeners();
  }

  //add akun poin
  void addReward(String nama, int req_poin) {
    final newReward = Reward(
      nama: nama,
      req_poin: req_poin,
      completed: 0,
    );
    DBHelper.instance.insertReward(newReward);
    notifyListeners();
  }

  List<Reward> getReward(int poin) {
    return _reward.where((element) => element.req_poin! <= poin).toList();
  }

  //updateReward
  void updateReward(int id, String nama, int req_poin, int completed) {
    final dataBaru = new Reward.withId(
      id: id,
      nama: nama,
      req_poin: req_poin,
      completed: completed,
    );
    _reward[_reward.indexWhere((element) => element.id == id)] = dataBaru;

    DBHelper.instance.updateReward(dataBaru);
    notifyListeners();
  }

  void getRewardUpdate(int id) {
    final dataBaru = _reward[_reward.indexWhere((element) => element.id == id)];
    dataBaru.completed = dataBaru.completed! + 1;
    DBHelper.instance.updateReward(dataBaru);
    notifyListeners();
  }

  //deleteKata
  void delete(int id) async {
    await DBHelper.instance.deleteReward(id);
    notifyListeners();
  }
}
