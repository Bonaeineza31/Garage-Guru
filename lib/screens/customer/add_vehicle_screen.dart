import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GgAppBar(
        title: 'Add Vehicle',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Image picker placeholder
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Icon(Icons.add, size: 40, color: AppColors.textHint),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xxxl),

            // Form fields
            GgTextField(
              label: 'Make',
              hint: 'Select make',
              suffix: Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
            ),
            SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'Model',
              hint: 'e.g. Camry, Corolla',
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: GgTextField(
                    label: 'Year',
                    hint: 'e.g. 2020',
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: GgTextField(
                    label: 'Color',
                    hint: 'e.g. Silver',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'License Plate Number',
              hint: 'e.g. RAA123A',
            ),
            SizedBox(height: AppSpacing.xxxl),

            GgButton(
              label: 'Add Vehicle',
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
