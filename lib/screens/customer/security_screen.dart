import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _loginNotifications = true;
  bool _suspiciousAlerts = true;
  bool _rememberDevice = true;
  bool _appLock = false;

  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Security',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECURITY STATUS
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 20),
                          SizedBox(width: AppSpacing.sm),
                          Text('Security Status', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Medium',
                          style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildSecurityRow(icon: Icons.access_time, label: 'Strong password', trailing: 'Updated 30 days ago', isOk: true),
                  _buildSecurityRow(icon: Icons.access_time, label: 'Two-factor authentication', trailing: 'Enable now', trailingTap: () {}, isOk: false),
                  _buildSecurityRow(icon: Icons.check_circle_outline, label: 'Recovery email verified', trailing: 'Kelly@gmail.com', isOk: true),
                  _buildSecurityRow(icon: Icons.check_circle_outline, label: 'Phone number verified', trailing: 'Verify now', trailingTap: () {}, isOk: false),
                  SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete 2 more steps to secure your account',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // PASSWORD MANAGEMENT
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_outline, size: 20),
                      SizedBox(width: AppSpacing.sm),
                      Text('Password Management', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  GgTextField(label: 'Current Password', hint: 'Enter current password', controller: _currentPwCtrl, obscureText: true),
                  SizedBox(height: AppSpacing.md),
                  GgTextField(label: 'New Password', hint: 'Enter new password', controller: _newPwCtrl, obscureText: true),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text('Password strength: ', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('Medium', style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
                      minHeight: 4,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  GgTextField(label: 'Confirm New Password', hint: 'Confirm new password', controller: _confirmPwCtrl, obscureText: true),
                  SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordRule('At least 8 characters'),
                      _buildPasswordRule('Contains uppercase letter'),
                      _buildPasswordRule('Contains number'),
                      _buildPasswordRule('Contains special character'),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  GgButton(
                    label: 'Update Password',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password updated!'), backgroundColor: AppColors.success),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // TWO-FACTOR AUTHENTICATION
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phonelink_lock_outlined, size: 20),
                      SizedBox(width: AppSpacing.sm),
                      Text('Two-Factor Authentication', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add an extra layer of security to your account by requiring both your password and a verification code from your mobile phone.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildTwoFAItem(icon: Icons.phone_iphone, title: 'Authenticator App', subtitle: 'Google Authenticator, Authy, etc.', buttonLabel: 'Set up', onTap: () {}),
                  SizedBox(height: AppSpacing.sm),
                  _buildTwoFAItem(icon: Icons.sms_outlined, title: 'SMS Verification', subtitle: 'Receive codes via text message', buttonLabel: 'Set up', onTap: () {}),
                  SizedBox(height: AppSpacing.sm),
                  _buildTwoFAItem(icon: Icons.lock_outline, title: 'Backup Codes', subtitle: "Use when you can't access other methods", buttonLabel: 'Generate', onTap: () {}),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // ACCOUNT ACTIVITY
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_outlined, size: 20),
                      SizedBox(width: AppSpacing.sm),
                      Text('Account Activity', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildDeviceItem(icon: Icons.smartphone, name: 'iPhone 13 Pro • Kigali, Rwanda', subtitle: 'Current device • Active now', isCurrent: true),
                  SizedBox(height: AppSpacing.sm),
                  _buildDeviceItem(icon: Icons.laptop_mac, name: 'MacBook Pro • Nairobi, Kenya', subtitle: 'Last active: 2 days ago', isCurrent: false),
                  SizedBox(height: AppSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('View all login activity', style: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // ADVANCED SECURITY
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Advanced Security', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: AppSpacing.md),
                  _buildSecurityToggle(title: 'Login Notifications', subtitle: 'Get alerts about new logins to your account', value: _loginNotifications, onChanged: (v) => setState(() => _loginNotifications = v)),
                  _buildSecurityToggle(title: 'Suspicious Activity Alerts', subtitle: 'Get notified about unusual account activity', value: _suspiciousAlerts, onChanged: (v) => setState(() => _suspiciousAlerts = v)),
                  _buildSecurityToggle(title: 'Remember This Device', subtitle: 'Stay logged in on this device', value: _rememberDevice, onChanged: (v) => setState(() => _rememberDevice = v)),
                  _buildSecurityToggle(title: 'App Lock', subtitle: 'Require authentication to open the app', value: _appLock, onChanged: (v) => setState(() => _appLock = v)),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Sign Out From All Devices',
                  style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Deactivate Account',
                  style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }

  Widget _buildPasswordRule(String rule) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
          SizedBox(width: 6),
          Text(rule, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required String label,
    required String trailing,
    VoidCallback? trailingTap,
    required bool isOk,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isOk ? AppColors.success : AppColors.textSecondary),
          SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
          GestureDetector(
            onTap: trailingTap,
            child: Text(
              trailing,
              style: AppTextStyles.caption.copyWith(
                color: trailingTap != null ? AppColors.primary : AppColors.textSecondary,
                fontWeight: trailingTap != null ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFAItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12),
            minimumSize: Size(0, 34),
            side: BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          ),
          child: Text(buttonLabel, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildDeviceItem({
    required IconData icon,
    required String name,
    required String subtitle,
    required bool isCurrent,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSecurityToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
