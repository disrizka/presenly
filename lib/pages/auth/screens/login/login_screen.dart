import 'package:flutter/material.dart';
import 'package:presenly/pages/auth/screens/register/register_screen.dart';
import 'package:presenly/pages/main/screens/bottom_navigator_bar.dart';
import 'package:presenly/service/auth_service.dart';
import 'package:presenly/service/pref_handler.dart';
import 'package:presenly/utils/constant/app_color.dart';
import 'package:presenly/utils/constant/app_font.dart';
import 'package:presenly/utils/constant/app_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showElegantSnackBar("Silakan isi email dan password Anda.");
      setState(() => _isLoading = false);
      return;
    }
    if (email.isEmpty) {
      _showElegantSnackBar("Email tidak boleh kosong.");
      setState(() => _isLoading = false);
      return;
    }
    if (password.isEmpty) {
      _showElegantSnackBar("Password tidak boleh kosong.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final user = await AuthService().login(email: email, password: password);
      await PreferenceHandler.saveId(user.id!);

      _showElegantSnackBar("Login berhasil.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomBar()),
      );
    } catch (e) {
      print(e);
      _showElegantSnackBar(e.toString().replaceAll("Exception: ", ""));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome back \nagain! Attendify \nto see you, Again!",
                    textAlign: TextAlign.left,
                    style: PoppinsTextStyle.bold.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 50),
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
                  const SizedBox(height: 70),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.backgroundColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              "Login",
                              style: PoppinsTextStyle.bold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                  ),
                  const SizedBox(height: 20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: PoppinsTextStyle.regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register here",
                          style: PoppinsTextStyle.bold.copyWith(
                            color: AppColor.tertiaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
