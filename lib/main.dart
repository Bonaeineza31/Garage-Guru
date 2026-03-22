import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:garage_guru/core/theme/theme_data.dart' as theme_data;
import 'package:garage_guru/core/theme/theme_provider.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const GarageGuruApp(),
    ),
  );
}

class GarageGuruApp extends StatelessWidget {
  const GarageGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'GarageGuru',
          debugShowCheckedModeBanner: false,
          theme: theme_data.AppTheme.lightTheme,
          darkTheme: theme_data.AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const LoginScreen(),
        );
      },
    );
  }
}
