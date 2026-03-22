import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      
      appBar: GgAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Profile image with edit icon
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profileImageUrl ?? 'https://i.pravatar.cc/150?img=1'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            // Form fields
            GgTextField(
              label: 'Full Name',
              hint: 'e.g. Kelly Johnson',
              controller: TextEditingController(text: user.fullName),
            ),
            const SizedBox(height: AppSpacing.lg),
            const GgTextField(
              label: 'Nickname',
              hint: 'e.g. Kelly',
            ),
            const SizedBox(height: AppSpacing.lg),
            const GgTextField(
              label: 'Bio',
              hint: 'Write something about yourself',
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'Email',
              hint: 'e.g. Kellyineza@gmail.com',
              controller: TextEditingController(text: user.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'Phone Number',
              hint: 'e.g. +250 78 123 4567',
              controller: TextEditingController(text: user.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            GgButton(
              label: 'Save Profile',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
