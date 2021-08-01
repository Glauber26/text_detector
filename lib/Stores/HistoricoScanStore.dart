import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class HistoricoScanStore {
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializaDatabase();
    }
    return _database;
  }

  Future<Database> inicializaDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path;

    if(Platform.isAndroid){
      path = directory.path + 'historicos';
    }else{
      path = directory.path + '/historicos';
    }

    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE tb_historico_scan(cd_scan INTEGER PRIMARY KEY AUTOINCREMENT, tx_scan TEXT, dt_cadastro DATETIME)',
    );
  }

  Future<int> insertScan(HistoricoScanner log) async {
    Database db = await this.database;
    var resultado = await db.insert('tb_historico_scan', log.toJson());
    return resultado;
  }

  Future deletaTodoHistorico() async {
    Database db = await this.database;
    db.delete('tb_historico_scan');
  }

  Future deletaItemHistorico(int cd_scan) async {
    Database db = await this.database;
    db.rawQuery('DELETE FROM tb_historico_scan WHERE cd_scan = $cd_scan');
  }

  Future<List<HistoricoScanner>> buscaTodoHistorico() async {
    Database db = await this.database;
    List<Map> maps = await db.rawQuery('SELECT * FROM tb_historico_scan ORDER BY dt_cadastro DESC');
    List<HistoricoScanner> listaLog = List();

    if (maps.length > 0) {
      List<Map<dynamic, dynamic>> listMap = maps.toList();
      listMap.forEach((element) {
        listaLog.add(HistoricoScanner.fromJson(element));
      });
      return listaLog;
    } else {
      return null;
    }
  }
}


class HistoricoScanner {
  int cdScan;
  String txScan;
  String dtCadastro;

  HistoricoScanner({this.txScan, this.dtCadastro, this.cdScan});

  HistoricoScanner.fromJson(Map<String, dynamic> json) {
    txScan = json['tx_scan'];
    dtCadastro = json['dt_cadastro'];
    cdScan = json['cd_scan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tx_scan'] = this.txScan;
    data['dt_cadastro'] = this.dtCadastro;
    data['cd_scan'] = this.cdScan;
    return data;
  }
}