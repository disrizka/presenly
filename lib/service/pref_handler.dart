import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _id = 'idUser';
  static const String _lookWelcoming = 'lookWelcoming';
  static const String _token = 'token';

  // For saving user id
  static Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_id, id);
  }

  static void saveLookWelcoming(bool look) {
    print('look: $look');
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_lookWelcoming, look);
    });
  }

  // For saving token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  //For getting user id
  static Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_id); 
  }

  //For getting look welcoming
  static Future getLookWelcoming() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool look = prefs.getBool(_lookWelcoming) ?? false;
    return look;
  }

  // For removing user id
  static Future<void> removeId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_id);
  }

  // For removing token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_token);
  }
}
