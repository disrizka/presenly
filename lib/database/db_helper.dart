// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/user_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('absensi.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         email TEXT NOT NULL UNIQUE,
//         password TEXT NOT NULL
//       )
//     ''');
//   }

//   Future<int> insertUser(UserModel user) async {
//     final db = await instance.database;
//     return await db.insert('users', user.toMap());
//   }

//   Future<int> updateUserName(int id, String newName) async {
//     final db = await instance.database;
//     return await db.update(
//       'users',
//       {'name': newName},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<UserModel?> getUserById(int id) async {
//     final db = await instance.database;
//     final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
//     if (result.isNotEmpty) {
//       return UserModel.fromMap(result.first);
//     }
//     return null;
//   }

//   Future<void> close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/absensi_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('absensi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
// Future<void> resetDatabase() async {
//   final dbPath = await getDatabasesPath();
//   final path = join(dbPath, 'absensi.db');

//   final file = File(path);
//   if (await file.exists()) {
//     await file.delete();
//     print("✅ Database lama dihapus");
//   }

//   _database = await _initDB('absensi.db');
//   print("✅ Database baru dibuat ulang");
// }
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE absen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        check_in TEXT,
        check_out TEXT,
        check_in_address TEXT,
        check_out_address TEXT,
        check_in_lat REAL,
        check_in_lng REAL,
        check_out_lat REAL,
        check_out_lng REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }

  // USERS
  Future<int> insertUser(UserModel user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUserName(int id, String newName) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  // ABSEN
  Future<int> insertCheckin(AbsensiModel absen) async {
    final db = await instance.database;
    return await db.insert('absen', absen.toMap());
  }

  Future<int> updateCheckout({
    required int userId,
    required String tanggal,
    required String checkOut,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final db = await instance.database;
    return await db.update(
      'absen',
      {
        'check_out': checkOut,
        'check_out_address': address,
        'check_out_lat': lat,
        'check_out_lng': lng,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'user_id = ? AND created_at LIKE ?',
      whereArgs: [userId, '$tanggal%'],
    );
  }

  Future<AbsensiModel?> getAbsensiByTanggal(int userId, String tanggal) async {
    final db = await instance.database;
    final result = await db.query(
      'absen',
      where: 'user_id = ? AND created_at LIKE ?',
      whereArgs: [userId, '$tanggal%'],
    );
    if (result.isNotEmpty) {
      return AbsensiModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<AbsensiModel>> getAllAbsensi(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'absen',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return result.map((e) => AbsensiModel.fromMap(e)).toList();
  }

  Future<int> deleteAbsensi(int id) async {
    final db = await instance.database;
    return await db.delete('absen', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
