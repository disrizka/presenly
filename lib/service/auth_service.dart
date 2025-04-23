import 'package:presenly/database/db_helper.dart';

import '../../../models/user_model.dart';

class AuthService {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = UserModel(name: name, email: email, password: password);
    final id = await DatabaseHelper.instance.insertUser(user);
    return UserModel(id: id, name: name, email: email, password: password);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      throw Exception("Email atau password salah");
    }

    return UserModel.fromMap(result.first);
  }
}
