import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
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
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _setCoordinatesFromCurrentLocation() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is denied.')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final lat = position.latitude;
      final lon = position.longitude;

      _latitudeController.text = lat.toStringAsFixed(6);
      _longitudeController.text = lon.toStringAsFixed(6);

      // Best-effort reverse geocoding for address convenience.
      try {
        final placemarks = await placemarkFromCoordinates(lat, lon);
        if (placemarks.isNotEmpty && _addressController.text.trim().isEmpty) {
          final pm = placemarks.first;
          final parts = <String?>[
            pm.street,
            pm.locality,
            pm.administrativeArea,
            pm.postalCode,
            pm.country,
          ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();
          if (parts.isNotEmpty) _addressController.text = parts.join(', ');
        }
      } catch (_) {
        // Ignore reverse geocode errors; user can still enter address manually.
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _setCoordinatesFromAddress() async {
    if (_isLoading) return;
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address first.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final locations = await locationFromAddress(_addressController.text.trim());
      if (locations.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find coordinates for that address.')),
        );
        return;
      }

      final loc = locations.first;
      _latitudeController.text = loc.latitude.toStringAsFixed(6);
      _longitudeController.text = loc.longitude.toStringAsFixed(6);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to geocode address: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final lat = double.parse(_latitudeController.text.trim());
    final lon = double.parse(_longitudeController.text.trim());

    final id = 'g${DateTime.now().microsecondsSinceEpoch}';
    final ownerId = MockData.currentUser.id;

    final emailText = _emailController.text.trim();
    final websiteText = _websiteController.text.trim();

    final garage = GarageModel(
      id: id,
      ownerId: ownerId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      latitude: lat,
      longitude: lon,
      phone: _phoneController.text.trim(),
      email: emailText.isEmpty ? null : emailText,
      website: websiteText.isEmpty ? null : websiteText,
      coverImageUrl: 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=800',
      galleryImages: const [],
      services: const [],
      specializations: const [],
      rating: 0.0,
      reviewCount: 0,
      isVerified: false,
      workingHours: const {},
      distanceKm: 0.0,
    );

    MockData.garages.add(garage);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GgAppBar(title: 'Add Garage', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Where is the garage located?', style: AppTextStyles.heading3),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Garage Name',
                  hint: 'e.g. Smith Auto Care',
                  controller: _nameController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Description',
                  hint: 'Short description of services',
                  controller: _descriptionController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Address',
                  hint: 'Street, city, etc.',
                  controller: _addressController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Address is required' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: GgButton(
                        label: 'From Address',
                        isOutlined: true,
                        icon: Icons.location_searching_rounded,
                        onPressed: _setCoordinatesFromAddress,
                        isLoading: _isLoading,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GgButton(
                        label: 'Current Location',
                        isOutlined: true,
                        icon: Icons.my_location_rounded,
                        onPressed: _setCoordinatesFromCurrentLocation,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: GgTextField(
                        label: 'Latitude',
                        hint: 'e.g. 37.7749',
                        controller: _latitudeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Latitude is required';
                          final parsed = double.tryParse(v.trim());
                          if (parsed == null) return 'Latitude must be a number';
                          if (parsed < -90 || parsed > 90) return 'Latitude must be between -90 and 90';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GgTextField(
                        label: 'Longitude',
                        hint: 'e.g. -122.4194',
                        controller: _longitudeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Longitude is required';
                          final parsed = double.tryParse(v.trim());
                          if (parsed == null) return 'Longitude must be a number';
                          if (parsed < -180 || parsed > 180) return 'Longitude must be between -180 and 180';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Phone',
                  hint: '+1 ...',
                  controller: _phoneController,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Email (optional)',
                  hint: 'info@example.com',
                  controller: _emailController,
                ),
                const SizedBox(height: AppSpacing.md),
                GgTextField(
                  label: 'Website (optional)',
                  hint: 'www.example.com',
                  controller: _websiteController,
                ),
                const SizedBox(height: AppSpacing.xxl),
                GgButton(
                  label: 'Add Garage',
                  icon: Icons.add_rounded,
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

