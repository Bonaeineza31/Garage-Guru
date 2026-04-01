

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/auth/auth_theme.dart';
import 'package:garage_guru/screens/auth/auth_widgets.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';
import 'package:garage_guru/screens/customer/privacy_policy_screen.dart';
import 'package:garage_guru/screens/customer/terms_of_service_screen.dart';
import 'package:garage_guru/screens/owner/owner_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  Future<void> _handleRegister() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms and Privacy Policy')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });
        try {
          await user.sendEmailVerification();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('We sent a verification link to your email. Check spam if you don’t see it.'),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Could not send verification email')),
            );
          }
        }
        if (!mounted) return;
        final destination =
            _selectedRole == 'garage_owner' ? const OwnerShell() : const CustomerShell();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => destination),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
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
              const SnackBar(
                content: Text('We sent a verification link to your email. Check spam if you don’t see it.'),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Could not send verification email')),
            );
          }
        }

        if (!mounted) return;
        final destination =
            _selectedRole == 'garage_owner' ? const OwnerShell() : const CustomerShell();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => destination),
          (route) => false,
        );
>>>>>>> c0b7a48c9430978b1a6d6587b5dcf3f5a6e3937e
>>>>>>> 2f8307a (refactor(auth): migrate authentication screens to new theme system)
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
>>>>>>> origin/main
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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: AuthTheme.title(context),
                ),
                const SizedBox(height: 10),
                Text(
                  'Join GarageGuru for reliable car repair services',
                  textAlign: TextAlign.center,
                  style: AuthTheme.subtitleStyle(context),
                ),
                const SizedBox(height: 14),
                _rolePicker(context),
                const SizedBox(height: 18),
                const AuthSocialRow(),
                const SizedBox(height: 20),
                const AuthOrDivider(),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _nameController,
                  hint: 'Uwera Maria',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _phoneController,
                  hint: '+250 78 123 4567',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  suffix: IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _confirmPasswordController,
                  hint: '••••••••',
                  obscureText: _obscureConfirm,
                  suffix: IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) return 'Passwords don\'t match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: AuthTheme.fieldBorder, width: 1.5),
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AuthTheme.primary;
                          }
                          return Colors.white;
                        }),
                        checkColor: Colors.white,
                        onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 0,
                          runSpacing: 4,
                          children: [
                            Text(
                              'I agree to the ',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const TermsOfServiceScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Terms of Service',
                                style: AppTextStyles.body.copyWith(
                                  color: AuthTheme.link,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            Text(
                              ' and ',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Privacy Policy',
                                style: AppTextStyles.body.copyWith(
                                  color: AuthTheme.link,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthPrimaryButton(
                  label: 'Create account',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in',
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

  Widget _rolePicker(BuildContext context) {
    final subtitle = AuthTheme.subtitleStyle(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Registering as ', style: subtitle.copyWith(fontSize: 13)),
        GestureDetector(
          onTap: () => setState(() => _selectedRole = 'customer'),
          child: Text(
            'Customer',
            style: subtitle.copyWith(
              fontSize: 13,
              fontWeight: _selectedRole == 'customer' ? FontWeight.w700 : FontWeight.w500,
              color: _selectedRole == 'customer' ? AuthTheme.link : AuthTheme.subtitle,
              decoration: _selectedRole == 'customer' ? TextDecoration.underline : null,
            ),
          ),
        ),
        Text('  ·  ', style: subtitle.copyWith(fontSize: 13)),
        GestureDetector(
          onTap: () => setState(() => _selectedRole = 'garage_owner'),
          child: Text(
            'Garage owner',
            style: subtitle.copyWith(
              fontSize: 13,
              fontWeight: _selectedRole == 'garage_owner' ? FontWeight.w700 : FontWeight.w500,
              color: _selectedRole == 'garage_owner' ? AuthTheme.link : AuthTheme.subtitle,
              decoration: _selectedRole == 'garage_owner' ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
