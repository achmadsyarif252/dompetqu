import 'dart:collection';

import 'package:dompet_q/helper/db_helper.dart';
import 'package:dompet_q/models/chart_data.dart';
import 'package:dompet_q/models/transaction.dart';
import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import 'package:intl/intl.dart';

class TransactionProvider with ChangeNotifier {
  //data source for listransaksi table
  List<Transaction> _userTransaction = [];

//get listtransaksi for consume in fE
  UnmodifiableListView get userTransaksi {
    return UnmodifiableListView(_userTransaction);
  }

//used by chart because chart cant consume UnmodifiableListview type

  List<Transaction> get userTransaksiChart {
    return [..._userTransaction];
  }

//source data for chart
  List<ChartData> _chartData = [];
//i think this method is not used anymore
  void addChartData() {
    _chartData.add(
      ChartData(
        tipe: "Pemasukan",
        total: income,
      ),
    );
    notifyListeners();
  }

  get totalData => userTransaksi.length;
  List<ChartData> get chartData {
    return UnmodifiableListView(_chartData);
  }

  Future<void> fetchAndSetTransaksi() async {
    final dataList = await DBHelper.instance.getTransactionList();
    _userTransaction = dataList
        .map(
          (txItem) => Transaction.withId(
            id: txItem['id'],
            name: txItem['nama'],
            total: txItem['total'],
            jenis: txItem['jenis'],
            tanggal: DateTime.now().toString(),
          ),
        )
        .toList();
    notifyListeners();
  }

  double get income {
    double total = 0;
    _userTransaction.forEach((element) {
      if (element.jenis == "1") {
        total += element.total!;
      }
    });
    return total;
  }

  double get outcome {
    double total = 0;
    _userTransaction.forEach((element) {
      if (element.jenis == "2") {
        total += element.total!;
      }
    });
    return total;
  }

  double get total {
    return (income - outcome) / 1000;
  }

  double get persentase {
    if (outcome > 0 || income > 0) return outcome / income * 100;
    return 0;
  }

  void addTransaction(
      String? name, double? total, DateTime tanggal, String jenisInput) {
    int id = _userTransaction.length + 1;
    Transaction newTransaction = new Transaction.withId(
      id: id,
      name: name!,
      total: total!,
      jenis: jenisInput,
      tanggal: tanggal.toString(),
    );
    _userTransaction.add(newTransaction);
    notifyListeners();

    DBHelper.instance.insert(newTransaction);

    // DBHelper.insert('list_transaksi', {
    //   'id': '',
    //   'nama': newTransaction.name,
    //   'jenis': jenisInput,
    //   'total': newTransaction.total,
    //   'tanggal': newTransaction.tanggal.toIso8601String(),
    // });
  }

  void deleteData(int itemId) async {
    await DBHelper.instance.delete(itemId);
    notifyListeners();
  }
}
