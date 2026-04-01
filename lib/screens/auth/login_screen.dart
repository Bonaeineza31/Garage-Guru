// TODO: Add password strength validation for login.
/// Login screen for GarageGuru.
/// Handles user authentication and email verification logic.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_guru/core/auth/auth_service.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/auth/forgot_password_screen.dart';
import 'package:garage_guru/screens/auth/register_screen.dart';
import 'package:garage_guru/screens/auth/auth_theme.dart';
import 'package:garage_guru/screens/auth/auth_widgets.dart';
import 'package:garage_guru/screens/auth/reset_password_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:garage_guru/screens/owner/owner_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    // TODO: Improve error handling for Google sign-in.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
      // Email verification logic: block access if not verified.
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        setState(() => _isLoading = false);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Email Not Verified'),
            content: const Text('Please verify your email before logging in.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await user.sendEmailVerification();
                  Navigator.of(ctx).pop();
                },
                child: const Text('Resend Verification'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerShell()),
      );
    } on FirebaseAuthException catch (e) {
      // Debug print for login failures
      debugPrint('Login failed: \\${e.code} - \\${e.message}');
      setState(() => _isLoading = false);
      String msg = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') msg = 'No user found for that email.';
      if (e.code == 'wrong-password') msg = 'Wrong password provided.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService.signInWithGoogle();
      final user = cred.user;
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> 2f8307a (refactor(auth): migrate authentication screens to new theme system)
import 'package:garage_guru/core/auth/auth_service.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/auth/forgot_password_screen.dart';
import 'package:garage_guru/screens/auth/register_screen.dart';
<<<<<<< HEAD
=======
=======
import 'package:garage_guru/core/theme/app_theme.dart';
=======
import 'package:garage_guru/theme/app_theme.dart';
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
import 'package:garage_guru/screens/auth/auth_theme.dart';
import 'package:garage_guru/screens/auth/auth_widgets.dart';
import 'package:garage_guru/screens/auth/register_screen.dart';
import 'package:garage_guru/screens/auth/reset_password_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:garage_guru/screens/owner/owner_shell.dart';
>>>>>>> c0b7a48c9430978b1a6d6587b5dcf3f5a6e3937e
>>>>>>> 2f8307a (refactor(auth): migrate authentication screens to new theme system)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential.user != null && mounted) {
        // AuthGate listens to auth state and routes by Firestore role.
      if (userCredential.user != null && mounted) {
        // AuthGate listens to auth state and routes by Firestore role.
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService.signInWithGoogle();
      final user = cred.user;
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: AppTextStyles.body.copyWith(
                                      color: AuthTheme.link,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ForgotPasswordScreen(
                              initialEmail: email.contains('@') ? email : null,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      ),
>>>>>>> 5d9c514 (firebase data)
                      child: Text(
                          'Sign up',
                          style: AppTextStyles.body.copyWith(
                            color: AuthTheme.link,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          'OR',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.divider.withOpacity(0.5))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  GgButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata,
                    isOutlined: true,
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? ', style: AppTextStyles.body),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
>>>>>>> 5d9c514 (firebase data)
            ),
          ),
        ),
      ),
    );
  }
}
