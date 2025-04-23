import 'package:presenly/database/checkin_database_helper.dart';
import 'package:presenly/models/checkin_model.dart';

class CheckinService {
  final CheckinDatabaseHelper _dbHelper = CheckinDatabaseHelper();

  Future<void> saveCheckin({
    required String address,
    required double lat,
    required double lng,
  }) async {
    final now = DateTime.now().toIso8601String();
    final checkin = CheckinModel(
      address: address,
      latitude: lat,
      longitude: lng,
      dateTime: now,
    );
    await _dbHelper.insertCheckin(checkin);
  }
}
