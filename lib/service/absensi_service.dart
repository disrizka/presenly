import 'package:presenly/database/db_helper.dart';
import 'package:presenly/models/absensi_model.dart';

class AbsensiService {
  Future<void> checkin({
    required int userId,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final now = DateTime.now();
    final tanggal = now.toIso8601String().substring(0, 10);
    final existing = await DatabaseHelper.instance.getAbsensiByTanggal(
      userId,
      tanggal,
    );
    if (existing != null) throw ("Kamu sudah check-in hari ini.");

    final absen = AbsensiModel(
      userId: userId,
      status: 'checkin',
      checkIn: now.toIso8601String(),
      createdAt: now.toIso8601String(),
      checkInAddress: address,
      checkInLat: lat,
      checkInLng: lng,
    );

    await DatabaseHelper.instance.insertCheckin(absen);
  }

  Future<void> checkout({
    required int userId,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final now = DateTime.now();
    final tanggal = now.toIso8601String().substring(0, 10);
    final existing = await DatabaseHelper.instance.getAbsensiByTanggal(
      userId,
      tanggal,
    );
    if (existing == null)
      throw ("Belum check-in, tidak bisa checkout.");
    if (existing.checkOut != null)
      throw ("Kamu sudah checkout hari ini.");

    await DatabaseHelper.instance.updateCheckout(
      userId: userId,
      tanggal: tanggal,
      checkOut: now.toIso8601String(),
      address: address,
      lat: lat,
      lng: lng,
    );
  }

  Future<List<AbsensiModel>> getRiwayatAbsensi(int userId) async {
    return await DatabaseHelper.instance.getAllAbsensi(userId);
  }

  Future<AbsensiModel?> getAbsensiHariIni(int userId) async {
    final tanggal = DateTime.now().toIso8601String().substring(0, 10);
    return await DatabaseHelper.instance.getAbsensiByTanggal(userId, tanggal);
  }

  Future<void> hapusAbsen(int id) async {
    await DatabaseHelper.instance.deleteAbsensi(id);
  }
}
