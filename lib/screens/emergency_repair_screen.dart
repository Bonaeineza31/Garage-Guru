import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

/// Emergency repair request screen for urgent vehicle issues
class EmergencyRepairScreen extends StatefulWidget {
  const EmergencyRepairScreen({super.key});

  @override
  State<EmergencyRepairScreen> createState() => _EmergencyRepairScreenState();
}

class _EmergencyRepairScreenState extends State<EmergencyRepairScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  bool _useCurrentLocation = false;

  @override
  void dispose() {
    _locationController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  GarageGuruTheme.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Emergency Repair'),
          ],
        ),
        backgroundColor:  GarageGuruTheme.emergencyOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Information banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  GarageGuruTheme.emergencyOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:  GarageGuruTheme.emergencyOrange.withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Emergency repairs are prioritized and will connect you with the nearest available mechanic.',
                style: TextStyle(
                  color:  GarageGuruTheme.emergencyOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Your Location section
            const Text(
              'Your Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:  GarageGuruTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Current location or address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              enabled: !_useCurrentLocation,
            ),

            const SizedBox(height: 12),

            // Use current location checkbox
            InkWell(
              onTap: () {
                setState(() {
                  _useCurrentLocation = !_useCurrentLocation;
                  if (_useCurrentLocation) {
                    _locationController.text = 'Using current location...';
                  } else {
                    _locationController.clear();
                  }
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.my_location,
                    color:  GarageGuruTheme.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Use current location',
                    style: TextStyle(
                      fontSize: 14,
                      color:  GarageGuruTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Describe the Issue section
            const Text(
              'Describe the Issue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:  GarageGuruTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _issueController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'What\'s happening with your car?\n(e.g: flat tire, won\'t start etc,...)',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 32),

            // Request Emergency Repair button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitEmergencyRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  GarageGuruTheme.emergencyOrange,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Request Emergency repair',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Contact section
            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:  GarageGuruTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildContactItem(
              icon: Icons.phone,
              title: '+250 789 123 456',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling emergency support...')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildContactItem(
              icon: Icons.access_time,
              title: '24/7 Emergency Support',
              subtitle: 'Average response time: 15 minutes',
              onTap: null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color:  GarageGuruTheme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:  GarageGuruTheme.emergencyOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color:  GarageGuruTheme.emergencyOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:  GarageGuruTheme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color:  GarageGuruTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitEmergencyRequest() {
    // Validate inputs
    if (!_useCurrentLocation && _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide your location'),
          backgroundColor:  GarageGuruTheme.errorRed,
        ),
      );
      return;
    }

    if (_issueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the issue'),
          backgroundColor:  GarageGuruTheme.errorRed,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color:  GarageGuruTheme.successGreen),
            const SizedBox(width: 8),
            const Text('Request Submitted'),
          ],
        ),
        content: const Text(
          'Your emergency repair request has been submitted. A mechanic will contact you shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
