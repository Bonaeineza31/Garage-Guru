import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garage_guru/core/theme/theme_data.dart';
import 'package:garage_guru/screens/auth/landing_screen.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const GarageGuruApp());
}

class GarageGuruApp extends StatelessWidget {
  const GarageGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GarageGuru',
      debugShowCheckedModeBanner: false,
      theme: GarageGuruTheme.lightTheme,
      home: const LandingScreen(),
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
