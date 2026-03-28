import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/screens/auth/auth_theme.dart';
import 'package:garage_guru/screens/auth/auth_widgets.dart';
import 'package:garage_guru/screens/auth/register_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email for a reset link.')),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Could not send reset email')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: AuthShell(
        onBack: () => Navigator.of(context).pop(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reset your password',
                  textAlign: TextAlign.center,
                  style: AuthTheme.title(context),
                ),
                const SizedBox(height: 10),
                Text(
                  "We'll send you a link to reset your password",
                  textAlign: TextAlign.center,
                  style: AuthTheme.subtitleStyle(context),
                ),
                const SizedBox(height: 28),
                AuthTextField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AuthPrimaryButton(
                  label: 'Send Reset Link',
                  isLoading: _loading,
                  onPressed: _sendLink,
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
