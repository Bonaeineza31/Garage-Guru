import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/map_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/emergency_repair_screen.dart';
import 'presentation/screens/request_repair_screen.dart';
import 'presentation/screens/tire_service_screen.dart';
import 'presentation/screens/battery_service_screen.dart';
import 'presentation/screens/garages_screen.dart';
import 'presentation/screens/repairs_screen.dart';
import 'presentation/screens/profile_screen.dart';

void main() {
  // Lock app to portrait mode for consistent UI
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GarageGuruApp());
}

class GarageGuruApp extends StatelessWidget {
  const GarageGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GarageGuru',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/emergency-repair': (context) => const EmergencyRepairScreen(),
        '/request-repair': (context) => const RequestRepairScreen(),
        '/tire-service': (context) => const TireServiceScreen(),
        '/battery-service': (context) => const BatteryServiceScreen(),
        '/garages': (context) => const GaragesScreen(),
        '/repairs': (context) => const RepairsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
