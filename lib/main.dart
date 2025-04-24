import 'package:flutter/material.dart';
import 'package:presenly/pages/auth/screens/register/register_screen.dart';
import 'package:presenly/utils/constant/app_color.dart';

void main() {
  runApp(const MyApp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ❗️ Reset paksa database sekali saja
//   await DatabaseHelper.instance.resetDatabase();

//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
      ),
      home: RegisterScreen(),
    );
  }
}