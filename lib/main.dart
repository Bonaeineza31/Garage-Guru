<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
// TODO: Add localization support for multi-language users.
// The MultiProvider below injects global state (theme, auth, garage, booking) for the entire app.
/// Main entry point for the GarageGuru app.
/// Handles Firebase initialization, theme, and global providers.
>>>>>>> b5bf330 (docs(main): add TODO for localization support)
=======
/// Main entry point for the GarageGuru app.
/// Handles Firebase initialization, theme, and global providers.
>>>>>>> c70b76e (docs: add file-level doc comments to main.dart, login_screen.dart, and register_screen.dart)
=======
/// Main entry point for the GarageGuru app.
/// Handles Firebase initialization, theme, and global providers.
>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:garage_guru/core/theme/theme_data.dart';
import 'package:garage_guru/screens/auth/auth_gate.dart';
import 'package:garage_guru/blocs/auth_bloc.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';
import 'package:garage_guru/blocs/booking_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/theme/theme_provider.dart';

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
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => GarageBloc()..add(LoadGarages())),
        BlocProvider(create: (context) => BookingBloc()),
      ],
      child: const GarageGuruApp(),
    ),
  );
}

class GarageGuruApp extends StatelessWidget {
    // The AuthGate widget controls navigation based on authentication state.
  const GarageGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'GarageGuru',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthGate(),
        );
      },
    );
  }
}
