import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();
  bool _isLoading = false;
  File? _vehicleImage;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _vehicleImage = File(pickedFile.path));
    }
  }

  final List<String> _carMakes = [
    'Toyota', 'BMW', 'Mercedes-Benz', 'Volkswagen', 'Ford', 
    'Honda', 'Hyundai', 'Nissan', 'Kia', 'Audi', 'Lexus', 
    'Land Rover', 'Mazda', 'Chevrolet', 'Jeep', 'Volkswagen', 'Peugeot', 'Renault'
  ];

  final Map<String, List<String>> _makeToModels = {
    'Toyota': ['Corolla', 'Camry', 'Rav4', 'Hilux', 'Land Cruiser', 'Yaris', 'Prado'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'X1', '7 Series', 'M3'],
    'Mercedes-Benz': ['C-Class', 'E-Class', 'S-Class', 'GLE', 'GLC', 'A-Class'],
    'Volkswagen': ['Golf', 'Polo', 'Passat', 'Tiguan', 'Touareg'],
    'Ford': ['Focus', 'Fiesta', 'Ranger', 'Everest', 'Mustang'],
    'Honda': ['Civic', 'Accord', 'CR-V', 'Fit'],
    'Hyundai': ['Elantra', 'Tucson', 'Santa Fe', 'i30'],
    'Nissan': ['Patrol', 'X-Trail', 'Navara', 'Qashqai'],
    // Default fallback
  };

  void _showModelSelection() {
    final make = _makeController.text;
    if (make.isEmpty) return;
    
    final models = _makeToModels[make] ?? ['Other'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select $make Model', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(models[index], style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {
                        setState(() => _modelController.text = models[index]);
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
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Vehicle Make', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _carMakes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_carMakes[index], style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {
                        setState(() {
                          _makeController.text = _carMakes[index];
                          _modelController.text = ''; // Reset model
                        });
                        Navigator.pop(context);
                        _showModelSelection();
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Logic for adding a vehicle with an image. 
      // Since firebase_storage is not in pubspec, we use a mock URL if an image was picked.
      String imageUrl = 'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?w=800'; // Default
      if (_vehicleImage != null) {
        // In a real app, upload _vehicleImage to Firebase Storage here
        imageUrl = 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800'; 
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('vehicles').add({
        'make': _makeController.text.trim(),
        'model': _modelController.text.trim(),
        'year': int.tryParse(_yearController.text.trim()) ?? 2020,
        'color': _colorController.text.trim(),
        'plateNumber': _plateController.text.trim().toUpperCase(),
        'imageUrl': imageUrl,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GgAppBar(
        title: 'Add Vehicle',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: Theme.of(context).dividerColor),
                          image: _vehicleImage != null 
                            ? DecorationImage(image: FileImage(_vehicleImage!), fit: BoxFit.cover)
                            : null,
                        ),
                        child: _vehicleImage == null 
                          ? Icon(Icons.directions_car_outlined, size: 40, color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : AppColors.textHint)
                          : null,
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
              ),
              const SizedBox(height: AppSpacing.xxxl),
  
              GgTextField(
                label: 'Make',
                hint: 'Select make',
                controller: _makeController,
                readOnly: true,
                onTap: _showMakeSelection,
                suffix: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
                validator: (v) => v == null || v.isEmpty ? 'Please select a make' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              GgTextField(
                label: 'Model',
                hint: 'Select model',
                controller: _modelController,
                readOnly: true,
                onTap: _showModelSelection,
                suffix: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
                validator: (v) => v == null || v.isEmpty ? 'Please select a model' : null,
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
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: GgTextField(
                      label: 'Color',
                      hint: 'e.g. Silver',
                      controller: _colorController,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              GgTextField(
                label: 'License Plate Number',
                hint: 'e.g. RAA123A',
                controller: _plateController,
                validator: (v) => v == null || v.isEmpty ? 'Please enter plate number' : null,
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
      ),
    );
  }
}
