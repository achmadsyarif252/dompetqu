import 'dart:async';
import 'dart:io';
import 'package:dompet_q/models/whistlist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as tx;
import '../models/whistlist.dart' as wl;
import '../models/habit_model.dart' as hT;
import '../models/ide_apps_model.dart' as iM;

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

  //column for ide_apps
  String table4 = 'ide';
  String colId4 = 'id';
  String colNama4 = 'nama';
  String colDetail = 'detail';
  String colIsDone = 'isDone';

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
    final transactionList =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return transactionList;
  }

//create required table in local storage using sqflite
  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colNama TEXT,$colTotal REAL,$colTanggal TEXT,$colJenis TEXT)');
    await db.execute(
        'CREATE TABLE $table2($colId2 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama2 TEXT,$colTotal2 REAL,$colTanggal2 TEXT,$colIsComplete INTEGER,$colCurrentDana REAL)');
    await db.execute(
        'CREATE TABLE $table3($colId3 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama3 TEXT,$colRepetisi INTEGER,$colTglStart TEXT)');
    await db.execute(
        'CREATE TABLE $table4($colId4 INTEGER PRIMARY KEY AUTOINCREMENT,$colNama4 TEXT,$colDetail TEXT,$colIsDone INTEGER)');
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

  //get data from tabel habit
  Future<List<Map<String, dynamic>>> getIdeApps() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table4);
    return result;
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

  Future<List<hT.Habbit>> getHabbit() async {
    final List<Map<String, dynamic>> habitMap = await getHabitList();
    final List<hT.Habbit> listHabit = [];
    habitMap.forEach((habbit) {
      listHabit.add(hT.Habbit.fromMap(habbit));
    });
    return listHabit;
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
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    print(id);
    return result;
  }
}
