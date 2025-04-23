import 'package:path/path.dart';
import 'package:presenly/models/checkin_model.dart';
import 'package:sqflite/sqflite.dart';

class CheckinDatabaseHelper {
  static final CheckinDatabaseHelper _instance = CheckinDatabaseHelper._internal();
  factory CheckinDatabaseHelper() => _instance;
  CheckinDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'checkin.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE checkins(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            address TEXT,
            latitude REAL,
            longitude REAL,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertCheckin(CheckinModel checkin) async {
    final db = await database;
    return await db.insert('checkins', checkin.toMap());
  }

  Future<List<CheckinModel>> getAllCheckins() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('checkins');
    return maps.map((map) => CheckinModel.fromMap(map)).toList();
  }
}
