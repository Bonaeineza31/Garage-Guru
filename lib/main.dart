// TODO: Add localization support for multi-language users.
// The MultiProvider below injects global state (theme, auth, garage, booking) for the entire app.
/// Main entry point for the GarageGuru app.
/// Handles Firebase initialization, theme, and global providers.
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
<<<<<<< HEAD
>>>>>>> 37073b2 (feat(main): integrate new theme and provider into app entrypoint)
>>>>>>> origin/main
import 'package:garage_guru/core/theme/theme_data.dart';
import 'package:garage_guru/screens/auth/auth_gate.dart';
<<<<<<< HEAD
import 'firebase_options.dart';
=======
=======
=======
import 'package:garage_guru/blocs/auth_bloc.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';
import 'package:garage_guru/blocs/booking_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/theme/theme_provider.dart';
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
import 'package:garage_guru/screens/auth/landing_screen.dart';
<<<<<<< HEAD
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'firebase_options.dart';
=======
>>>>>>> c0b7a48c9430978b1a6d6587b5dcf3f5a6e3937e
>>>>>>> 37073b2 (feat(main): integrate new theme and provider into app entrypoint)
>>>>>>> origin/main

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
<<<<<<< HEAD
=======
  
>>>>>>> origin/main
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
  const GarageGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'GarageGuru',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
<<<<<<< HEAD
    );
  }
}
=======
=======
      home: const LandingScreen(),
>>>>>>> c0b7a48c9430978b1a6d6587b5dcf3f5a6e3937e
=======
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'GarageGuru',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthWrapper(),
        );
      },
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return LandingScreen();
      },
    );
  }
}
>>>>>>> 37073b2 (feat(main): integrate new theme and provider into app entrypoint)
