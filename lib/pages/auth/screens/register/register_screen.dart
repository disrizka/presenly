import 'package:flutter/material.dart';
import 'package:presenly/pages/auth/screens/login/login_screen.dart';
import 'package:presenly/service/auth_service.dart';
import 'package:presenly/service/pref_handler.dart';
import 'package:presenly/utils/constant/app_color.dart';
import 'package:presenly/utils/constant/app_font.dart';
import 'package:presenly/utils/constant/app_image.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await AuthService().register(
        name: name,
        email: email,
        password: password,
      );

      // Simpan ID user ke SharedPreferences
      if (response.id != null) {
        await PreferenceHandler.saveId(response.id!);
      }

      _showElegantSnackBar("Register berhasil!");

      // Redirect ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.isNotEmpty) {
        _showElegantSnackBar(errorMessage);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Helper untuk menampilkan SnackBar dengan gaya elegan
  void _showElegantSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Text(
                "Hallo! Register \nto opened",
                style: PoppinsTextStyle.bold.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 20),

              // Nama
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nama",
                  hintStyle: PoppinsTextStyle.regular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: PoppinsTextStyle.regular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: PoppinsTextStyle.regular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Register
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.primaryColor),
                  foregroundColor: AppColor.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : _handleRegister,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                          "Register",
                          style: PoppinsTextStyle.bold.copyWith(fontSize: 16),
                        ),
              ),
              const SizedBox(height: 20),

              // Or login with
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or login with",
                      style: PoppinsTextStyle.regular.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Sosial Media
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(AppImage.facebook),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: Image.asset(AppImage.google),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: Image.asset(AppImage.apple),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Link ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do have an account? ",
                    style: PoppinsTextStyle.regular.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login here",
                      style: PoppinsTextStyle.bold.copyWith(
                        color: AppColor.tertiaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
