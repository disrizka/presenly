import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presenly/database/db_helper.dart';
import 'package:presenly/pages/auth/screens/login/login_screen.dart';
import 'package:presenly/service/pref_handler.dart';
import 'package:presenly/utils/constant/app_color.dart';
import 'package:presenly/utils/constant/app_font.dart';
import 'package:presenly/utils/constant/app_image.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = "Loading...";
  String email = "Loading...";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final darkMode = await ThemePreference.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });
    await ThemePreference.saveDarkMode(value);
    
    // Here you would normally also update your app's theme
    // If you're using a theme provider or state management solution
  }

  Future<void> fetchProfile() async {
    final userId = await PreferenceHandler.getId();
    if (userId != null) {
      final user = await DatabaseHelper.instance.getUserById(userId);
      if (user != null) {
        setState(() {
          name = user.name;
          email = user.email;
          nameController.text = user.name;
          emailController.text = user.email;
        });
      }
    }
  }

  Future<void> _editProfileDialog() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Text(
              "Edit Profile",
              style: PoppinsTextStyle.semiBold.copyWith(fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Batal",
                  style: PoppinsTextStyle.medium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.save, color: AppColor.backgroundColor),
                label: Text(
                  "Simpan",
                  style: PoppinsTextStyle.semiBold.copyWith(fontSize: 14),
                ),
                onPressed: () async {
                  final userId = await PreferenceHandler.getId();
                  if (userId != null) {
                    try {
                      await DatabaseHelper.instance.updateUserName(
                        userId,
                        nameController.text,
                      );
                      setState(() {
                        name = nameController.text;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Nama berhasil diperbarui"),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal update: $e")),
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  void _signOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Konfirmasi Sign Out',
              style: PoppinsTextStyle.semiBold.copyWith(fontSize: 16),
            ),
            content: Text(
              'Apakah Anda yakin ingin keluar dari aplikasi?',
              style: PoppinsTextStyle.regular.copyWith(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Batal',
                  style: PoppinsTextStyle.medium.copyWith(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
                child: Text('Ya, Keluar', style: PoppinsTextStyle.medium),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    await PreferenceHandler.removeId();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    Widget? trailing,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: trailing == null ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.grey.shade700, size: 22),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: PoppinsTextStyle.medium.copyWith(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                trailing ?? Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 24, thickness: 0.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: PoppinsTextStyle.bold.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[800],
                      foregroundImage: AssetImage(AppImage.demoUser),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: PoppinsTextStyle.semiBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: PoppinsTextStyle.regular.copyWith(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _editProfileDialog,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildSection("Pengaturan Akun", [
              _buildSettingItem(
                icon: Icons.person,
                title: "Akun Saya",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: "Privasi & Keamanan",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.notifications_none_rounded,
                title: "Notifikasi",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.help_outline_rounded,
                title: "Bantuan",
                onTap: () {},
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 20),
            _buildSection("Tampilan", [
              _buildSettingItem(
                icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: "Mode Gelap",
                onTap: () {},
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: _toggleTheme,
                  activeColor: Colors.deepOrange,
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSection("Tentang Aplikasi", [
              _buildSettingItem(
                icon: Icons.info_outline_rounded,
                title: "Tentang Attendify",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.star_border_rounded,
                title: "Beri Rating",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.policy_outlined,
                title: "Kebijakan Privasi",
                onTap: () {},
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout, color: AppColor.backgroundColor),
              label: Text(
                "Sign Out",
                style: PoppinsTextStyle.semiBold.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PoppinsTextStyle.semiBold.copyWith(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }
}

// Add this class to handle theme preferences
class ThemePreference {
  static const String _darkModeKey = 'darkMode';

  // Save dark mode preference
  static Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  // Get dark mode preference
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false; // Default to light mode
  }
}