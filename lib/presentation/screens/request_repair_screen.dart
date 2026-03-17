import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

/// Standard repair request screen for scheduled maintenance
class RequestRepairScreen extends StatefulWidget {
  const RequestRepairScreen({super.key});

  @override
  State<RequestRepairScreen> createState() => _RequestRepairScreenState();
}

class _RequestRepairScreenState extends State<RequestRepairScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  String? _selectedRepairType;
  String? _selectedVehicle;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Request Repair'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Repair Type dropdown
            const Text(
              'Repair Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedRepairType,
              decoration: const InputDecoration(
                hintText: 'Select Repair type',
                prefixIcon: Icon(Icons.build_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'oil_change',
                  child: Text('Oil Change'),
                ),
                DropdownMenuItem(
                  value: 'tire_service',
                  child: Text('Tire Service'),
                ),
                DropdownMenuItem(
                  value: 'battery',
                  child: Text('Battery Service'),
                ),
                DropdownMenuItem(value: 'brake', child: Text('Brake Service')),
                DropdownMenuItem(value: 'engine', child: Text('Engine Repair')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRepairType = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Date and Time section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            _dateController.text =
                                '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '--:-- --',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            _timeController.text = time.format(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Location section
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Where should the mechanic meet you?',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: 20),

            // Vehicle dropdown
            const Text(
              'Vehicle',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedVehicle,
              decoration: const InputDecoration(
                hintText: 'Select your vehicle',
                prefixIcon: Icon(Icons.directions_car_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'toyota_camry',
                  child: Text('Toyota Camry - RAC 881C'),
                ),
                DropdownMenuItem(
                  value: 'honda_accord',
                  child: Text('Honda Accord - RAB 123A'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedVehicle = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Issue Description
            const Text(
              'Issue Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _issueController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe the issue with your vehicle',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitRequest,
                child: const Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  void _submitRequest() {
    // Validate all fields
    if (_selectedRepairType == null) {
      _showError('Please select a repair type');
      return;
    }

    if (_dateController.text.isEmpty) {
      _showError('Please select a date');
      return;
    }

    if (_timeController.text.isEmpty) {
      _showError('Please select a time');
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _showError('Please enter a location');
      return;
    }

    if (_selectedVehicle == null) {
      _showError('Please select a vehicle');
      return;
    }

    if (_issueController.text.trim().isEmpty) {
      _showError('Please describe the issue');
      return;
    }

    // Show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successGreen),
            const SizedBox(width: 8),
            const Text('Request Submitted'),
          ],
        ),
        content: const Text(
          'Your repair request has been submitted successfully. You will receive a confirmation shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorRed),
    );
  }
}
