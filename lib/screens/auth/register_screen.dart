import 'package:flutter/material.dart';
import 'package:garage_guru/screens/auth/auth_ui.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) return;
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await credential.user?.sendEmailVerification();
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Verify Your Email'),
          content: const Text('A verification link has been sent to your email. Please verify before logging in.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String msg = 'Registration failed. Please try again.';
      if (e.code == 'email-already-in-use') msg = 'Email already in use.';
      if (e.code == 'invalid-email') msg = 'Invalid email address.';
      if (e.code == 'weak-password') msg = 'Password is too weak.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthUi.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Form(
            key: _formKey,
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthBackButton(onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(height: 8),
                  const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AuthUi.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join GarageGuru for reliable car repair services',
                    style: TextStyle(fontSize: 13, color: AuthUi.textMuted, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const AuthSocialRow(),
                  const SizedBox(height: 12),
                  const AuthDivider(),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Full Name',
                    placeholder: 'Full Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Email address',
                    placeholder: 'Email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Phone number',
                    placeholder: 'Phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Phone is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Password',
                    placeholder: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                        color: const Color(0xFF7B8794),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Confirm Password',
                    placeholder: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                        color: const Color(0xFF7B8794),
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return 'Passwords don\'t match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                        activeColor: AuthUi.blue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              const Text(
                                'I agree to the ',
                                style: TextStyle(fontSize: 12, color: AuthUi.textMuted, height: 1.35),
                              ),
                              Text(
                                'Terms of service',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AuthUi.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                ' and ',
                                style: TextStyle(fontSize: 12, color: AuthUi.textMuted, height: 1.35),
                              ),
                              Text(
                                'Privacy Policy',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AuthUi.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AuthPrimaryButton(
                    label: 'Create account',
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (!_acceptedTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please accept the terms to continue.')),
                              );
                              return;
                            }
                            _handleRegister();
                          },
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: AuthUi.textMuted)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AuthUi.blue,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text('Sign in'),
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