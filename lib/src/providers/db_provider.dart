import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader_flutter/src/models/scan_model.dart';
export 'package:qr_reader_flutter/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    _database = _database != null ? _database : await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  rawInsert(ScanModel scanModel) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        "VALUES (${scanModel.id}, '${scanModel.tipo}', '${scanModel.valor}')");
    return res;
  }

  insert(ScanModel scanModel) async {
    final db = await database;
    final res = await db.insert('Scans', scanModel.toJson());
    return res;
  }

  Future<ScanModel> getById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAll() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =
        res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getByTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  Future<int> update(ScanModel scanModel) async {
    final db = await database;

    final res = await db.update('Scans', scanModel.toJson(),
        where: 'id = ?', whereArgs: [scanModel.id]);
    return res;
  }

  Future<int> delete(int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
