import 'dart:async';
import 'dart:io';
import 'package:dompet_q/models/whistlist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as tx;
import '../models/whistlist.dart' as wl;
import '../models/habit_model.dart' as hT;
import '../models/ide_apps_model.dart' as iM;
import '../models/kamus_model.dart' as kM;
import '../models/point_model.dart' as pM;
import '../models/reward_model.dart' as rM;
import '../models/counter.dart' as cR;
import 'package:provider/provider.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._instance();
  static Database? _db;

  DBHelper._instance();

//column for list_transaksi tabel
  String table = "list_transaksi";
  String colId = 'id';
  String colNama = 'nama';
  String colTotal = 'total';
  String colTanggal = 'tanggal';
  String colJenis = 'jenis';

  //column for whistlist tabel
  String table2 = 'whistlist';
  String colId2 = 'id';
  String colNama2 = 'nama';
  String colTotal2 = 'total';
  String colTanggal2 = 'tanggal';
  String colIsComplete = 'isComplete';
  String colCurrentDana = 'currentDana';

  //column for habit_maker
  String table3 = 'habit';
  String colId3 = 'id';
  String colNama3 = 'nama';
  String colRepetisi = 'repetisi';
  String colTglStart = 'tanggal';
  String colUpdatedAt = 'updatedAt';
  String colPoinGain = 'poinGain';

  //column for ide_apps
  String table4 = 'ide';
  String colId4 = 'id';
  String colNama4 = 'nama';
  String colDetail = 'detail';
  String colIsDone = 'isDone';

  //column for kamus
  String table5 = 'kamus';
  String colId5 = 'id';
  String colKata = 'kata';
  String colArti = 'arti';

  //column for point;
  String table6 = 'mypoin';
  String colId6 = 'id';
  String colNama6 = 'nama';
  String colPoin = 'poin';
  String colTtlReward = 'ttl_reward';

  //column for reward
  String table7 = 'myreward';
  String colId7 = 'id';
  String colNama7 = 'nama';
  String colReqPoin = 'req_poin';
  String colCompleted = 'completed';

  //column for counter
  String table8 = 'counter';
  String colId8 = 'id';
  String colNama8 = 'nama';
  String colTotal8 = 'total';

//inisialisasi database
  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

// inisialisasi database
  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'dompet.db';
    final transactionList = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
      // onUpgrade: _onUpgrade,
    );
    return transactionList;
  }

//create required table in local storage using sqflite
  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colNama TEXT,$colTotal REAL,$colTanggal TEXT,$colJenis TEXT)');
    await db.execute(
        'CREATE TABLE $table2($colId2 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama2 TEXT,$colTotal2 REAL,$colTanggal2 TEXT,$colIsComplete INTEGER,$colCurrentDana REAL)');
    await db.execute(
        'CREATE TABLE $table3($colId3 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama3 TEXT,$colRepetisi INTEGER,$colTglStart TEXT,$colUpdatedAt TEXT,$colPoinGain)');
    await db.execute(
        'CREATE TABLE $table4($colId4 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama4 TEXT,$colDetail TEXT,$colIsDone INTEGER)');
    await db.execute(
        'CREATE TABLE $table5($colId5 INTEGER PRIMARY KEY AUTOINCREMENT,$colKata TEXT,$colArti TEXT)');
    await db.execute(
        'CREATE TABLE $table6($colId6 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama6 TEXT,$colPoin INTEGER,$colTtlReward INTEGER)');
    await db.execute(
        'CREATE TABLE $table7($colId7 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama7 TEXT,$colReqPoin INTEGER,$colCompleted INTEGER)');
    await insertPoint(db);
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute(
          "CREATE TABLE $table8($colId8 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama8 TEXT,$colTotal8 INTEGER)");
    }
  }

  //get data from tabel counter
  Future<List<Map<String, dynamic>>> getCounter() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table8);
    return result;
  }

  //get data from tabel list_transaksi
  Future<List<Map<String, dynamic>>> getTransactionList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table);
    return result;
  }

  //get data from tabel whistlist
  Future<List<Map<String, dynamic>>> getWhistList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table2);
    return result;
  }

  //get data from tabel habit
  Future<List<Map<String, dynamic>>> getHabitList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table3);
    return result;
  }

  //get data from tabel ideApps
  Future<List<Map<String, dynamic>>> getIdeApps() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table4);
    return result;
  }

  //get data from tabel kamus
  Future<List<Map<String, dynamic>>> getKamus() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table5);
    return result;
  }

  //get data from tabel point
  Future<List<Map<String, dynamic>>> getPoint() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table6);
    return result;
  }

  //get data from tabel reward
  Future<List<Map<String, dynamic>>> getReward() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table7);
    return result;
  }

  //get data from tabel counter and return as model counter
  Future<List<cR.Counter>> getCounterList() async {
    final List<Map<String, dynamic>> counterMapList = await getCounter();
    final List<cR.Counter> counter = [];
    counterMapList.forEach((counterMap) {
      counter.add(cR.Counter.fromMap(counterMap));
    });
    return counter;
  }

  //get data from tabel list_transaksi and return as model transaksi
  Future<List<tx.Transaction>> getTransList() async {
    final List<Map<String, dynamic>> transMapList = await getTransactionList();
    final List<tx.Transaction> transactionList = [];
    transMapList.forEach((transMap) {
      transactionList.add(tx.Transaction.fromMap(transMap));
    });
    return transactionList;
  }

  //get data from tabel ide_apps and return as apss model
  Future<List<iM.IdeApps>> getIde() async {
    final List<Map<String, dynamic>> ideAppsListMap = await getIdeApps();
    final List<iM.IdeApps> listIde = [];
    ideAppsListMap.forEach((ideMap) {
      listIde.add(iM.IdeApps.fromMap(ideMap));
    });
    return listIde;
  }

  //get data from tabel list_transaksi and return as model whistlist
  Future<List<wl.WhistList>> getwish() async {
    final List<Map<String, dynamic>> wishMapList = await getWhistList();
    final List<wl.WhistList> whistList = [];
    wishMapList.forEach((wishMap) {
      whistList.add(wl.WhistList.fromMap(wishMap));
    });
    return whistList;
  }

  //get data from tabel habit and return as model habiti
  Future<List<hT.Habbit>> getHabbit() async {
    final List<Map<String, dynamic>> habitMap = await getHabitList();
    final List<hT.Habbit> listHabit = [];
    habitMap.forEach((habbit) {
      listHabit.add(hT.Habbit.fromMap(habbit));
    });
    return listHabit;
  }

  //get data from tabel kamus and return as model kamus list
  Future<List<kM.Kamus>> getListKata() async {
    final List<Map<String, dynamic>> kamusMap = await getKamus();
    final List<kM.Kamus> listkata = [];
    kamusMap.forEach((kamus) {
      listkata.add(kM.Kamus.fromMap(kamus));
    });
    return listkata;
  }

  //get data from tabel point and return as model point list
  Future<List<pM.Point>> getListPoint() async {
    final List<Map<String, dynamic>> pointMap = await getPoint();
    final List<pM.Point> listPoint = [];
    pointMap.forEach((point) {
      listPoint.add(pM.Point.fromMap(point));
    });
    return listPoint;
  }

  //get data from tabel point and return as model point list
  Future<List<rM.Reward>> getListReward() async {
    final List<Map<String, dynamic>> rewardMap = await getReward();
    final List<rM.Reward> listReward = [];
    rewardMap.forEach((reward) {
      listReward.add(rM.Reward.fromMap(reward));
    });
    return listReward;
  }

  //Insert counter baru
  Future<int> insertCounter(cR.Counter counterX) async {
    Database db = await this.db;
    final int result = await db.insert(table8, counterX.toMap());
    return result;
  }

//insert traansaksi baru
  Future<int> insert(tx.Transaction transX) async {
    Database db = await this.db;
    final int result = await db.insert(table, transX.toMap());
    return result;
  }

  //insert whistlist baru
  Future<int> insertWhistList(wl.WhistList whistList) async {
    Database db = await this.db;
    final int result = await db.insert(table2, whistList.toMap());
    return result;
  }

  //insert new habbit
  Future<int> insertHabbit(hT.Habbit habbit) async {
    Database db = await this.db;
    final int result = await db.insert(table3, habbit.toMap());
    return result;
  }

  //insert new ide
  Future<int> inserIde(iM.IdeApps ide) async {
    Database db = await this.db;
    final int result = await db.insert(table4, ide.toMap());
    return result;
  }

  //insert new kata
  Future<int> insertKata(kM.Kamus kata) async {
    Database db = await this.db;
    final int result = await db.insert(table5, kata.toMap());
    return result;
  }

  //insert new point
  Future<void> insertPoint(Database db) async {
    pM.Point poin = pM.Point(nama: "DEFAULT", poin: 0, ttl_reward: 0);
    await db.insert(table6, poin.toMap());
  }

  //insert new reward
  Future<int> insertReward(rM.Reward reward) async {
    Database db = await this.db;
    final int result = await db.insert(table7, reward.toMap());
    return result;
  }

    //update transaksi tabel not used yet
  Future<int> updateCounter(cR.Counter counterX) async {
    Database db = await this.db;
    final int result = await db.update(
      table,
      counterX.toMap(),
      where: '$colId= ?',
      whereArgs: [counterX.id],
    );
    return result;
  }

  //update transaksi tabel not used yet
  Future<int> update(tx.Transaction transX) async {
    Database db = await this.db;
    final int result = await db.update(
      table,
      transX.toMap(),
      where: '$colId= ?',
      whereArgs: [transX.id],
    );
    return result;
  }

  Future<int> updateStatus(wl.WhistList wL) async {
    Database db = await this.db;
    final int result = await db.update(
      table2,
      wL.toMap(),
      where: '$colId= ?',
      whereArgs: [wL.id],
    );
    return result;
  }

  //update habbit
  Future<int> updateHabbit(hT.Habbit habbit) async {
    Database db = await this.db;
    final int result = await db.update(
      table3,
      habbit.toMap(),
      where: '$colId3= ?',
      whereArgs: [habbit.id],
    );
    return result;
  }

  //update ideApps
  Future<int> updateIde(iM.IdeApps ide) async {
    Database db = await this.db;
    final int result = await db.update(
      table4,
      ide.toMap(),
      where: '$colId4= ?',
      whereArgs: [ide.id],
    );
    return result;
  }

  //update ideApps
  Future<int> updatekata(kM.Kamus kata) async {
    Database db = await this.db;
    final int result = await db.update(
      table5,
      kata.toMap(),
      where: '$colId5= ?',
      whereArgs: [kata.id],
    );
    return result;
  }

  //update poin
  Future<int> updatePoint(pM.Point poin) async {
    Database db = await this.db;
    final int result = await db.update(
      table6,
      poin.toMap(),
      where: '$colId6= ?',
      whereArgs: [poin.id],
    );
    return result;
  }

  //update reward
  Future<int> updateReward(rM.Reward reward) async {
    Database db = await this.db;
    final int result = await db.update(
      table7,
      reward.toMap(),
      where: '$colId7= ?',
      whereArgs: [reward.id],
    );
    return result;
  }

//detele data from list_transaksi by id
  Future<int> delete(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table,
      where: '$colId= ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteWhistList(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table2,
      where: '$colId2= ?',
      whereArgs: [id],
    );
    return result;
  }

  //delete habbit from table
  Future<int> deleteHabbit(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table3,
      where: '$colId3= ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteIde(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table4,
      where: '$colId4= ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteKata(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table5,
      where: '$colId5= ?',
      whereArgs: [id],
    );
    return result;
  }

  //Delete Reward
  Future<int> deleteReward(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      table7,
      where: '$colId7= ?',
      whereArgs: [id],
    );
    return result;
  }
}
