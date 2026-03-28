import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';

class BookingScreen extends StatefulWidget {
  final GarageModel garage;
  /// When set (e.g. from a service row or tag), the booking dropdown selects this option.
  final String? initialServiceType;

  const BookingScreen({
    super.key,
    required this.garage,
    this.initialServiceType,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedService;
  int _selectedDateIndex = 1;
  int _selectedTimeIndex = 2;
  bool _isLoading = false;
  final _notesController = TextEditingController();

  final List<String> _services = [
    'General Maintenance',
    'Tire Replacement',
    'Oil Change',
    'Engine Diagnostics',
    'Brake Repair',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = _mapGarageServiceName(widget.initialServiceType);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final doc = FirebaseFirestore.instance.collection('bookings').doc();
      await doc.set({
        'id': doc.id,
        'userId': user?.uid ?? '',
        'garageId': widget.garage.id,
        'garageName': widget.garage.name,
        'garageAddress': widget.garage.address,
        'serviceName': _selectedService,
        'scheduledDate': _dates[_selectedDateIndex],
        'scheduledTime': _times[_selectedTimeIndex],
        'notes': _notesController.text.trim(),
        'status': 'mechanicOnWay',
        'progressPercent': 0.0,
        'mechanicName': 'Pending assignment',
        'mechanicSpecialty': '',
        'mechanicRating': 0.0,
        'vehicleMake': '',
        'vehicleModel': '',
        'vehiclePlate': '',
        'partsCost': 0.0,
        'laborCost': 0.0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: const Text('Booking Confirmed!'),
          content: const Text('Your appointment has been successfully booked. You can track it in the Repairs screen.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close booking screen
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _mapGarageServiceName(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    const aliases = {
      'Brake Pad Replacement': 'Brake Repair',
      'Tire Rotation': 'Tire Replacement',
      'Battery Replacement': 'General Maintenance',
      'Full Inspection': 'General Maintenance',
      'AC Repair': 'General Maintenance',
      'Transmission Service': 'General Maintenance',
    };
    final key = raw.trim();
    final mapped = aliases[key] ?? key;
    if (_services.contains(mapped)) return mapped;
    if (_services.contains(key)) return key;
    return null;
  }

  final List<String> _dates = ['Mon 12', 'Tue 13', 'Wed 14', 'Thu 15', 'Fri 16'];
  final List<String> _times = ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '04:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garage info quick summary
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    widget.garage.coverImageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.garage_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.garage.name, style: AppTextStyles.subtitle),
                      Text(widget.garage.address.split(',').last.trim(), style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            
            Text('Select Service', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _selectedService,
              hint: const Text('Choose a service'),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              items: _services.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _selectedService = val),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            Text('Choose Date', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedDateIndex == index;
                  final split = _dates[index].split(' ');
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDateIndex = index),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            split[0],
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            split[1],
                            style: AppTextStyles.subtitle.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            Text('Choose Time', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: List.generate(_times.length, (index) {
                final isSelected = _selectedTimeIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight.withOpacity(0.3) : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      _times[index],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            Text('Add Notes', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Any specific issues or requests...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
            const SizedBox(height: 100), // spacing for bottom sheet
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Estimate', style: AppTextStyles.caption),
                    Text('--', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GgButton(
                  label: _isLoading ? 'Booking...' : 'Confirm Booking',
                  useGradient: true,
                  onPressed: _isLoading ? null : _confirmBooking,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}