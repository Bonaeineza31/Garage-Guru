import 'package:flutter/material.dart';

class AuthUi {
  AuthUi._();

  static const Color blue = Color(0xFF4DA3D9);
  static const Color bg = Color(0xFFF3F6FB);
  static const Color cardBorder = Color(0xFFEEF2F6);
  static const Color inputFill = Color(0xFFF6F8FB);
  static const Color inputBorder = Color(0xFFE6EBF1);
  static const Color textPrimary = Color(0xFF1F2933);
  static const Color textMuted = Color(0xFF7B8794);

  static const double radius = 14;
  static const double inputRadius = 10;
}

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AuthUi.radius),
        border: Border.all(color: AuthUi.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: child,
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const AuthBackButton({
    super.key,
    required this.onPressed,
    this.label = 'Back to home',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF52606D),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(0, 0),
      ),
      child: Text('← $label'),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, this.text = 'OR CONTINUE WITH'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AuthUi.inputBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9AA5B1),
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AuthUi.inputBorder)),
      ],
    );
  }
}

class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    Widget chip(String text, String semanticsLabel) {
      return Semantics(
        button: true,
        label: semanticsLabel,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF52606D),
            side: const BorderSide(color: AuthUi.inputBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthUi.inputRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: chip('G', 'Continue with Google')),
        const SizedBox(width: 10),
        Expanded(child: chip('f', 'Continue with Facebook')),
        const SizedBox(width: 10),
        Expanded(child: chip('', 'Continue with Apple')),
      ],
    );
  }
}

class AuthTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AuthUi.textMuted,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFFA8B3BF)),
            filled: true,
            fillColor: AuthUi.inputFill,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthUi.inputRadius),
              borderSide: const BorderSide(color: AuthUi.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthUi.inputRadius),
              borderSide: const BorderSide(color: AuthUi.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthUi.inputRadius),
              borderSide: const BorderSide(color: AuthUi.blue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthUi.blue,
          disabledBackgroundColor: const Color(0xFFB8C2CC),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthUi.inputRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

