import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:collection/collection.dart';
import 'package:presenly/database/db_helper.dart';
import 'package:presenly/models/absensi_model.dart';
import 'package:presenly/pages/main/screens/bottom_navigator_bar.dart';
import 'package:presenly/service/pref_handler.dart';
import 'package:presenly/utils/constant/app_color.dart';
import 'package:presenly/utils/constant/app_font.dart';
import 'package:presenly/utils/constant/app_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<AbsensiModel> _historyList = [];
  bool _isLoading = true;
  Map<String, List<AbsensiModel>> _groupedHistory = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) => fetchHistory());
  }

  Future<void> fetchHistory() async {
    final userId = await PreferenceHandler.getId();
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      final data = await DatabaseHelper.instance.getAllAbsensi(userId);
      final grouped = groupBy(data, (AbsensiModel absen) {
        final date = DateTime.parse(absen.createdAt);
        return DateFormat('yyyy-MM-dd').format(date);
      });
      setState(() {
        _historyList = data;
        _groupedHistory = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ambil data: $e")),
      );
    }
  }

  Future<void> _deleteAbsen(int? absenId) async {
    if (absenId == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Absensi"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteAbsensi(absenId);
      fetchHistory();
    }
  }

  String _formatTanggal(String iso) {
    final date = DateTime.parse(iso);
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  String _formatJam(String? iso) {
    if (iso == null) return "-";
    return DateFormat.Hm().format(DateTime.parse(iso));
  }

  String _formatDisplayDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'History',
          style: PoppinsTextStyle.bold.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomBar())),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHistoryInfoBox(),
                Expanded(
                  child: _groupedHistory.isEmpty
                      ? Center(child: Text(
                          "Tidak ada riwayat absensi.",
                          style: PoppinsTextStyle.bold.copyWith(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _groupedHistory.length,
                          itemBuilder: (context, index) {
                            final dateKey = _groupedHistory.keys.elementAt(index);
                            final absensiList = _groupedHistory[dateKey]!;
                            final absensi = absensiList.first;
                            final id = absensi.id;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 24),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatDisplayDate(dateKey),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _deleteAbsen(id),
                                      ),
                                    ],
                                  ),
                                ),
                                if (absensi.checkIn != null)
                                  _buildAttendanceItem(
                                    icon: Icons.login,
                                    iconColor: AppColor.successColor,
                                    title: "Check In",
                                    time: _formatJam(absensi.checkIn),
                                    address: absensi.checkInAddress ?? '',
                                  ),
                                if (absensi.checkOut != null)
                                  _buildAttendanceItem(
                                    icon: Icons.logout,
                                    iconColor: AppColor.erorColor,
                                    title: "Check Out",
                                    time: _formatJam(absensi.checkOut),
                                    address: absensi.checkOutAddress ?? '',
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildAttendanceItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String address,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left:2 ),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
              
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PoppinsTextStyle.semiBold.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  address,
                  style: PoppinsTextStyle.regular.copyWith(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              time,
              style: PoppinsTextStyle.semiBold.copyWith(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryInfoBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(AppImage.historyImage, width: 145, height: 93),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cek History mu disini",
                    style: PoppinsTextStyle.bold.copyWith(
                      fontSize: 14,
                      color: AppColor.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tinggalkan kebiasaan telat kamu, yaa dan tetap semangat!",
                    style: PoppinsTextStyle.regular.copyWith(
                      fontSize: 10,
                      color: AppColor.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}