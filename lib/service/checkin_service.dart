// import 'package:presenly/database/checkin_database_helper.dart';
// import 'package:presenly/models/checkin_model.dart';

// class CheckinService {
//   final CheckinDatabaseHelper _dbHelper = CheckinDatabaseHelper();

//   Future<void> saveCheck({
//     required String address,
//     required double lat,
//     required double lng,
//     required String type, // checkin / checkout
//   }) async {
//     final now = DateTime.now().toIso8601String();
//     final check = CheckinModel(
//       address: address,
//       latitude: lat,
//       longitude: lng,
//       dateTime: now,
//     );
//     await _dbHelper.insertCheckin(check);
//   }

//   Future<List<CheckinModel>> getAllChecks() async {
//     return await _dbHelper.getAllCheckins();
//   }

//   Future<void> clearAll() async {
//     await _dbHelper.clearCheckins();
//   }
// }
