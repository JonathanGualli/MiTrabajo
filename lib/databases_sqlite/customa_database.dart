import 'package:mi_trabajo/models/custon_activity_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomADatabase {
  static final CustomADatabase instance = CustomADatabase
      ._init(); // Patron estatico que me permite referenciar la propia clase

  static Database? _database;

  CustomADatabase._init(); // Crea una instancia de la base de datos

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('miTatabjo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //INTEGER
    //TEXT
    //BOLEAN
    //BLOB

    await db.execute('''
      CREATE TABLE $tableCustomActity(
        ${CustomActivityField.nameActivity} TEXT PRIMARY KEY,
        ${CustomActivityField.price} REAL NO NULL,
        ${CustomActivityField.icon} INTEGER NO NULL,
        ${CustomActivityField.color} TEXT NO NULL
        )
      ''');
  }

  Future<String> addCustomActivity(CustomActivityModel customA) async {
    final db = await instance.database;
/*     await db.insert(
        tableCustomActity, customA.toJson()); // El json envia un mapa. */
    try {
      await db.insert(
        tableCustomActity,
        customA.toJson(),
        conflictAlgorithm: ConflictAlgorithm
            .fail, // Esto hará que falle la inserción si ya existe una llave primaria duplicada
      );
      return "true";
    } on DatabaseException catch (e) {
      //print(e);
      if (e.isUniqueConstraintError()) {
        return "existe";
      }
      return ('Error: $e');
    }
  }

  Future<List<CustomActivityModel>> getAllCustomA() async {
    final db = await instance.database;
    final results = await db.query(tableCustomActity);
    return results
        .map((mapCustomActivitys) =>
            CustomActivityModel.fromJson(mapCustomActivitys))
        .toList();
  }

  Future<void> deleteCustomA(String nameActivity) async {
    final db = await instance.database;
    await db.delete(tableCustomActity,
        where: '${CustomActivityField.nameActivity} = ?',
        whereArgs: [nameActivity]);
  }

  // Para cerrar la base de datos.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
