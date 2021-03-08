//import 'dart:html';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    //nesecitamos el path donde almaacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);
    //Crear base de Datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE Scans(
        id INTEGER PRIMARY KEY,
        tipo TEXT,
        valor TEXT
      )
      ''');
    });
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;
    //verificar la base de datos
    final db = await database;
    //insercion en la BD.
    final res = await db.rawInsert('''
    INSERT INTO Scans(id, tipo, valor)
    VALUES ($id, '$tipo', $valor)
    ''');
    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    //hacer el uso de estos metodos prefabricados incluyen metodos de seguridad
    //que hacen frente a inyecciones SQL
    final res = await db.insert('Scans', nuevoScan.toJson());
    print(res);
    //esta variable res si se imprime representa al ultimo numero ID
    //que se inserto
    return res;
  }

// la sig. secc. muestra la parte de los Selects.
//imaginamos tener un scan por ID
  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
// en la linea que se espera la respuesta del await y se almacena en res
//la busqueda devuelve un mapa de strin y dinamico. pero sabemos que en
//este caso no suceder por que solo hara la consulta a la columna Id.

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //FUNCION PARA OBTENER TODOS LOS SCANS
  Future<List<ScanModel>> getTodosLosScan() async {
    final db = await database;
    final res = await db.query('Scans');
    // en la linea que se espera la respuesta del await y se almacena en res
    //la busqueda devuelve un mapa de strin y dinamico. pero sabemos que en
    //este caso no suceder por que solo hara la consulta a la columna Id.

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : null;
  }

//FUNCION PARA OBTENER LOS SCANS POR TIPO.
  Future<List<ScanModel>> getTodosLosScan() async {
    final db = await database;
    final res = await db.query('Scans');
    // en la linea que se espera la respuesta del await y se almacena en res
    //la busqueda devuelve un mapa de strin y dinamico. pero sabemos que en
    //este caso no suceder por que solo hara la consulta a la columna Id.

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : null;
  }
}
