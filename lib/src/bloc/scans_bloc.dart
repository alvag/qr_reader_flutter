import 'dart:async';

import 'package:qr_reader_flutter/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._() {
    getScans();
  }

  final _scansConstroller = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansConstroller.stream;

  dispose() {
    _scansConstroller?.close();
  }

  getScans() async {
    _scansConstroller.sink.add(await DBProvider.db.getAll());
  }

  insertScan(ScanModel scan) async {
    await DBProvider.db.insert(scan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.delete(id);
    getScans();
  }

  deleteAll() async {
    await DBProvider.db.deleteAll();
    getScans();
  }
}
