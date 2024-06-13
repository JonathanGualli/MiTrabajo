import 'package:mi_trabajo/models/database_models.dart';
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
    await db.execute('''
            CREATE TABLE $tableActivityData(
        ${ActivityField.activityId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ActivityField.activityType} TEXT NO NULL,
        ${ActivityField.date} TEXT NO NULL,
        ${ActivityField.details} TEXT NO NULL,
        ${ActivityField.price} REAL NO NULL,
        ${ActivityField.quantity} INTEGER NO NULL,
        ${ActivityField.state} TEXT NO NULL
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

  Future<void> addActivity(ActivityModel activity) async {
    final db = await instance.database;
    await db.insert(tableActivityData, activity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<List<CustomActivityModel>> getAllCustomA() async {
    final db = await instance.database;
    final results = await db.query(tableCustomActity);
    return results
        .map((mapCustomActivitys) =>
            CustomActivityModel.fromJson(mapCustomActivitys))
        .toList();
  }

  Future<List<ActivityModel>> getActivities() async {
    final db = await instance.database;
    final results = await db.query(tableActivityData);
    return results
        .map((mapActivities) => ActivityModel.fromJson(mapActivities))
        .toList();
  }

  Future<void> deleteCustomA(String nameActivity) async {
    final db = await instance.database;
    await db.delete(tableCustomActity,
        where: '${CustomActivityField.nameActivity} = ?',
        whereArgs: [nameActivity]);
  }

  Future<void> deleteActivity(String activityId) async {
    final db = await instance.database;
    await db.delete(tableActivityData,
        where: '${ActivityField.activityId} = ?', whereArgs: [activityId]);
  }

  // Para cerrar la base de datos.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
