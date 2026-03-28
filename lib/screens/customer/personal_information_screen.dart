import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String _selectedGender = 'Female';
  final _fullNameCtrl = TextEditingController(text: 'Kelly Johnson');
  final _nicknameCtrl = TextEditingController(text: 'Kelly');
  final _bioCtrl = TextEditingController();
  final _emailCtrl = TextEditingController(text: 'kellyineza@gmail.com');
  final _phoneCtrl = TextEditingController(text: '78 123 4567');
  final _altEmailCtrl = TextEditingController();
  final _emergencyCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Rwanda');
  final _cityCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _linkedInCtrl = TextEditingController();
  final _twitterCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _fullNameCtrl, _nicknameCtrl, _bioCtrl, _emailCtrl, _phoneCtrl,
      _altEmailCtrl, _emergencyCtrl, _countryCtrl, _cityCtrl, _addressCtrl,
      _postalCtrl, _websiteCtrl, _linkedInCtrl, _twitterCtrl, _instagramCtrl,
    ]) {
      c.dispose();
    }
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
          'Personal Information',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BASIC INFORMATION
            _buildSectionHeader(Icons.person_outline, 'Basic Information'),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Full Name *', controller: _fullNameCtrl),
            const SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'Nickname',
              hint: 'Displayed to others',
              controller: _nicknameCtrl,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Gender
            Text('Gender', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: ['Female', 'Male', 'Other'].map((g) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: g,
                      groupValue: _selectedGender,
                      onChanged: (v) => setState(() => _selectedGender = v!),
                      activeColor: AppColors.primary,
                    ),
                    Text(g, style: AppTextStyles.body),
                    const SizedBox(width: 8),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Date of Birth
            Text('Date of Birth', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _buildDropdown('Day', ['5', '10', '15', '20', '25'], '5')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(flex: 2, child: _buildDropdown('Month', ['January', 'June', 'July'], 'June')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildDropdown('Year', ['1990', '1995', '2000'], '1990')),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your birthday will not be shown publicly',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),

            GgTextField(
              label: 'Bio',
              hint: 'Brief description about yourself',
              controller: _bioCtrl,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.xl),

            // CONTACT INFORMATION
            _buildSectionHeader(Icons.alternate_email, 'Contact Information'),
            const SizedBox(height: AppSpacing.md),
            GgTextField(
              label: 'Email Address *',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Primary email for notifications',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Manage emails', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Phone row with country code
            Text('Phone Number', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Text('+250 ', style: AppTextStyles.body),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textHint),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: GgTextField(label: '', hint: '78 123 4567', controller: _phoneCtrl, keyboardType: TextInputType.phone)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Used for account recovery', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Verify', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Alternative Email', hint: 'Add alternative email', controller: _altEmailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Emergency Contact', hint: 'Name and phone number', controller: _emergencyCtrl),
            const SizedBox(height: 4),
            Text('Only used in case of emergencies', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xl),

            // LOCATION INFORMATION
            _buildSectionHeader(Icons.location_on_outlined, 'Location Information'),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Country/Region', hint: 'Rwanda', controller: _countryCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'City', hint: 'City', controller: _cityCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Address', hint: 'Street address', controller: _addressCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Postal/ZIP Code', hint: 'Postal code', controller: _postalCtrl),
            const SizedBox(height: AppSpacing.xl),

            // SOCIAL PROFILES
            _buildSectionHeader(Icons.people_outline, 'Social Profiles'),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Website', hint: 'https://yourwebsite.com', controller: _websiteCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'LinkedIn', hint: 'LinkedIn profile URL', controller: _linkedInCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Twitter/X', hint: 'Twitter/X username', controller: _twitterCtrl),
            const SizedBox(height: AppSpacing.md),
            GgTextField(label: 'Instagram', hint: 'Instagram username', controller: _instagramCtrl),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {},
              child: const Text('+ Add More Social Profiles'),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: GgButton(
                    label: 'Save Changes',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GgButton(
                    label: 'Cancel',
                    isOutlined: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTextStyles.body))).toList(),
        onChanged: (v) {},
      ),
    );
  }
}
