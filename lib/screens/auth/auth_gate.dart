import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage_guru/core/auth/auth_service.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:garage_guru/screens/owner/owner_shell.dart';

/// Listens to Firebase Auth and loads the Firestore user profile to pick the home shell.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _AuthLoadingScaffold();
        }

        final user = authSnap.data;
        if (user == null) {
          return const LoginScreen();
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, docSnap) {
            if (docSnap.connectionState == ConnectionState.waiting) {
              return const _AuthLoadingScaffold();
            }

            final doc = docSnap.data;
            if (doc == null || !doc.exists) {
              return _BootstrapFirestoreProfile(user: user);
            }

            final role = doc.data()?['role'] ?? 'customer';
            return role == 'garage_owner'
                ? const OwnerShell()
                : const CustomerShell();
          },
        );
      },
    );
  }
}

class _AuthLoadingScaffold extends StatelessWidget {
  const _AuthLoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

/// First sign-in (e.g. Google) may not have a Firestore row yet; create it once.
class _BootstrapFirestoreProfile extends StatefulWidget {
  const _BootstrapFirestoreProfile({required this.user});

  final User user;

  @override
  State<_BootstrapFirestoreProfile> createState() => _BootstrapFirestoreProfileState();
}

class _BootstrapFirestoreProfileState extends State<_BootstrapFirestoreProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    try {
      await AuthService.ensureUserDocument(widget.user);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
