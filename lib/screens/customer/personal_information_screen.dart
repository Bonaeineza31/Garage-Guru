import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String _selectedGender = 'Female';
  String _profileImageUrl = 'https://i.pravatar.cc/150?img=1';
  File? _imageFile;
  
  final _fullNameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailCtrl.text = user.email ?? '';
      _fullNameCtrl.text = user.displayName ?? '';
      if (user.photoURL != null) {
        setState(() => _profileImageUrl = user.photoURL!);
      }
      
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          final data = doc.data()!;
          setState(() {
            _fullNameCtrl.text = data['name'] ?? _fullNameCtrl.text;
            _nicknameCtrl.text = data['nickname'] ?? '';
            _phoneCtrl.text = data['phone'] ?? '';
            _selectedGender = data['gender'] ?? 'Female';
            _cityCtrl.text = data['city'] ?? '';
            _addressCtrl.text = data['address'] ?? '';
          });
        }
      } catch (e) {
        // Log Error
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _fullNameCtrl.text,
        'nickname': _nicknameCtrl.text,
        'phone': _phoneCtrl.text,
        'gender': _selectedGender,
        'city': _cityCtrl.text,
        'address': _addressCtrl.text,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Personal Information',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) 
                        : NetworkImage(_profileImageUrl) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(Icons.person_outline, 'Basic Information'),
                const SizedBox(height: AppSpacing.md),
                GgTextField(label: 'Full Name *', controller: _fullNameCtrl),
                const SizedBox(height: AppSpacing.lg),
                GgTextField(label: 'Nickname', controller: _nicknameCtrl, hint: 'Displayed to others'),
                const SizedBox(height: AppSpacing.lg),
                
                Text('Gender', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
                Row(
                  children: ['Female', 'Male', 'Other'].map((g) => Row(children: [
                    Radio<String>(value: g, groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v!), activeColor: AppColors.primary),
                    Text(g, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 8),
                  ])).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),

                _buildSectionHeader(Icons.alternate_email, 'Contact Information'),
                const SizedBox(height: AppSpacing.md),
                GgTextField(label: 'Email Address *', controller: _emailCtrl, keyboardType: TextInputType.emailAddress, readOnly: true),
                const SizedBox(height: AppSpacing.md),
                GgTextField(label: 'Phone Number', controller: _phoneCtrl, keyboardType: TextInputType.phone, hint: '78 123 4567'),
                const SizedBox(height: AppSpacing.xl),

                _buildSectionHeader(Icons.location_on_outlined, 'Location Info'),
                const SizedBox(height: AppSpacing.md),
                GgTextField(label: 'City', controller: _cityCtrl),
                const SizedBox(height: AppSpacing.md),
                GgTextField(label: 'Address', controller: _addressCtrl, hint: 'Street address'),
                const SizedBox(height: AppSpacing.xxl),

                Row(
                  children: [
                    Expanded(child: GgButton(label: 'Save Changes', onPressed: _saveChanges)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: GgButton(label: 'Cancel', isOutlined: true, onPressed: () => Navigator.pop(context))),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.7), size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
