import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class AddGarageScreen extends StatefulWidget {
  const AddGarageScreen({super.key});

  @override
  State<AddGarageScreen> createState() => _AddGarageScreenState();
}

class _AddGarageScreenState extends State<AddGarageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  LatLng? _selectedLocation;
  bool _isLoading = false;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please drop a pin on the map')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = FirebaseFirestore.instance.collection('garages').doc();
      await docRef.set({
        'id': docRef.id,
        'ownerId': user.uid,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'coverImageUrl': 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=800',
        'rating': 0.0,
        'reviewCount': 0,
        'isVerified': false,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Garage successfully added!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding garage: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    if (_selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected'),
          position: _selectedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return Scaffold(
      appBar: const GgAppBar(title: 'Add New Garage'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GgTextField(
                  label: 'Garage Name',
                  hint: 'Enter your garage name',
                  controller: _nameController,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Description',
                  hint: 'Describe your services',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Address',
                  hint: 'Enter physical address',
                  controller: _addressController,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Phone Number',
                  hint: 'Enter contact number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Garage Location',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tap on the map to drop a pin for your garage coordinates.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.divider),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(37.7749, -122.4194),
                      zoom: 12,
                    ),
                    markers: markers,
                    onTap: (latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                      });
                    },
                    onMapCreated: (controller) => _mapController = controller,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                GgButton(
                  label: 'Add Garage',
                  onPressed: _submit,
                  isLoading: _isLoading,
                  useGradient: true,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
