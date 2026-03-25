import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

/// Tire service booking screen with service options
class TireServiceScreen extends StatefulWidget {
  const TireServiceScreen({super.key});

  @override
  State<TireServiceScreen> createState() => _TireServiceScreenState();
}

class _TireServiceScreenState extends State<TireServiceScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedServiceType;
  String? _selectedGarage;
  String? _selectedVehicle;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
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
        title: const Text('Tire Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Service info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.tire_repair,
                      color: AppTheme.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tire Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Professional tire care for your vehicle',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Service options grid
            Row(
              children: [
                Expanded(
                  child: _buildServiceOption(
                    title: 'Tire Replacement',
                    price: 'From Frw 20,000',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildServiceOption(
                    title: 'Tire Rotation',
                    price: 'From Frw 15,000',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildServiceOption(
                    title: 'Wheel Alignment',
                    price: 'From Frw 25,000',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildServiceOption(
                    title: 'Tire Pressure',
                    price: 'From Frw 5,000',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Book Battery Service section
            const Text(
              'Book Battery Service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Service Type dropdown
            const Text(
              'Service Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedServiceType,
              decoration: const InputDecoration(
                hintText: 'Select service type',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'replacement',
                  child: Text('Tire Replacement'),
                ),
                DropdownMenuItem(
                  value: 'rotation',
                  child: Text('Tire Rotation'),
                ),
                DropdownMenuItem(
                  value: 'alignment',
                  child: Text('Wheel Alignment'),
                ),
                DropdownMenuItem(
                  value: 'pressure',
                  child: Text('Tire Pressure Check'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedServiceType = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Garage dropdown
            const Text(
              'Garage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedGarage,
              decoration: const InputDecoration(hintText: 'Select a garage'),
              items: const [
                DropdownMenuItem(
                  value: 'auto_finit',
                  child: Text('Auto Finit - 0.6km'),
                ),
                DropdownMenuItem(
                  value: 'kigali_motors',
                  child: Text('Kigali Motors - 1.2km'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGarage = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Date and Time
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

            // Location
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
                hintText: 'Where should the service be done?',
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

            const SizedBox(height: 32),

            // Book Service button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _bookService,
                child: const Text(
                  'Book Service',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOption({required String title, required String price}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  void _bookService() {
    // Validate inputs
    if (_selectedServiceType == null ||
        _selectedGarage == null ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _locationController.text.trim().isEmpty ||
        _selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successGreen),
            const SizedBox(width: 8),
            const Text('Booking Confirmed'),
          ],
        ),
        content: const Text('Your tire service has been booked successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
