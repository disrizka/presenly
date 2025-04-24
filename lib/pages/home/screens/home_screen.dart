import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presenly/pages/auth/screens/login/login_screen.dart';
import 'package:presenly/pages/check-in/screens/checkin_screen.dart';
import 'package:presenly/pages/check-out/screens/checkout_screen.dart';
import 'package:presenly/pages/history/screens/history_screen.dart';
import 'package:presenly/utils/constant/app_color.dart';
import 'package:presenly/utils/constant/app_font.dart';
import 'package:presenly/utils/constant/app_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime now = DateTime.now();

  final List<Map<String, dynamic>> features = [];

  @override
  void initState() {
    super.initState();
    features.addAll([
      {'title': 'Izin', 'icon': AppImage.iconIzin, 'screen': null},
      {'title': 'Tugas', 'icon': AppImage.iconTugas, 'screen': null},
      {'title': 'Lembur In', 'icon': AppImage.iconLemburin, 'screen': null},
      {'title': 'Lembur Out', 'icon': AppImage.iconLemburout, 'screen': null},
      {'title': 'Cek Absen', 'icon': AppImage.iconCekabsen, 'screen': null},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a').format(now);
    String formattedDate = DateFormat('E, dd MMMM yyyy').format(now);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,

        title: Text(
          'Presenly',
          style: PoppinsTextStyle.bold.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              child: Image.asset(AppImage.demoUser),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBox(),
                  const SizedBox(height: 24),
                  _buildLiveAttendance(context, formattedTime, formattedDate),
                  const SizedBox(height: 16),
                  _buildCheckButtons(context),
                ],
              ),
            ),

            // Fitur Lainnya
            _buildSectionTitle("Lainnya"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          if (features[index]['screen'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => features[index]['screen'],
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          width: 80,
                          child: _buildFeatureItem(
                            features[index]['title'],
                            features[index]['icon'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Berita
            _buildSectionTitle("Berita"),
            _buildNewsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(Icons.search, color: AppColor.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search in here',
                hintStyle: PoppinsTextStyle.regular.copyWith(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAttendance(BuildContext context, String time, String date) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Live Attendance',
                style: PoppinsTextStyle.semiBold.copyWith(fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.access_time, color: AppColor.primaryColor),
                ),
              ),
            ),
          ],
        ),

        Center(
          child: Text(
            time,
            style: PoppinsTextStyle.bold.copyWith(fontSize: 32),
          ),
        ),
        Center(
          child: Text(
            date,
            style: PoppinsTextStyle.regular.copyWith(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CheckinScreen()),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              "Check in",
              style: PoppinsTextStyle.semiBold.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              "Check out",
              style: PoppinsTextStyle.semiBold.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String iconAsset) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Image.asset(
            iconAsset,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
                    Icon(_getIconForTitle(title), size: 40, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: PoppinsTextStyle.medium.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: PoppinsTextStyle.bold.copyWith(fontSize: 16)),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    List<Map<String, String>> newsItems = [
      {
        'title': 'Berita seputar virus Corona Hari ini',
        'time': '2 jam yang lalu',
      },
      {
        'title': 'Berita seputar sidang DPR Hari ini',
        'time': '2 jam yang lalu',
      },
      {
        'title': 'Update terbaru kebijakan perusahaan',
        'time': '3 jam yang lalu',
      },
      {
        'title': 'Perubahan jadwal kerja mulai bulan depan',
        'time': '4 jam yang lalu',
      },
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(right: 16),
            child: _buildNewsCard(
              newsItems[index]['title']!,
              newsItems[index]['time']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Row(
              children: [
                Image.asset(
                  AppImage.iconBerita,
                  width: 80,
                  height: 80,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.article,
                        size: 40,
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: PoppinsTextStyle.bold.copyWith(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            right: 0,
            child: Text(
              time,
              style: PoppinsTextStyle.regular.copyWith(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Izin':
        return Icons.person;
      case 'Tugas':
        return Icons.assignment;
      case 'Lembur In':
        return Icons.access_time;
      case 'Lembur Out':
        return Icons.exit_to_app;
      case 'Cek Absen':
        return Icons.checklist;
      default:
        return Icons.apps;
    }
  }
}
