import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();
  bool _isLoading = false;

  final List<String> _carMakes = [
    'Toyota', 'BMW', 'Mercedes-Benz', 'Volkswagen', 'Ford', 
    'Honda', 'Hyundai', 'Nissan', 'Kia', 'Audi', 'Lexus', 
    'Land Rover', 'Mazda', 'Chevrolet', 'Jeep'
  ];

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _showMakeSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Vehicle Make', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _carMakes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_carMakes[index], style: const TextStyle(fontFamily: 'Poppins')),
                      onTap: () {
                        setState(() => _makeController.text = _carMakes[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addVehicle() async {
    if (_makeController.text.isEmpty || _modelController.text.isEmpty || _plateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('vehicles').add({
        'make': _makeController.text,
        'model': _modelController.text,
        'year': _yearController.text,
        'color': _colorController.text,
        'plateNumber': _plateController.text,
        'imageUrl': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800', // Default placeholder
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle added successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding vehicle: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: GgAppBar(
        title: 'Add Vehicle',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: isDark ? Colors.white10 : AppColors.divider),
                    ),
                    child: Icon(Icons.directions_car_outlined, size: 40, color: isDark ? Colors.white : AppColors.textHint),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            GgTextField(
              label: 'Make',
              hint: 'Select make',
              controller: _makeController,
              readOnly: true,
              onTap: _showMakeSelection,
              suffix: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
            ),
            const SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'Model',
              hint: 'e.g. Camry, Corolla',
              controller: _modelController,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: GgTextField(
                    label: 'Year',
                    hint: 'e.g. 2020',
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: GgTextField(
                    label: 'Color',
                    hint: 'e.g. Silver',
                    controller: _colorController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            GgTextField(
              label: 'License Plate Number',
              hint: 'e.g. RAA123A',
              controller: _plateController,
            ),
            const SizedBox(height: AppSpacing.xxxl),

            if (_isLoading)
              const CircularProgressIndicator()
            else
              GgButton(
                label: 'Add Vehicle',
                onPressed: _addVehicle,
              ),
          ],
        ),
      ),
    );
  }
}
