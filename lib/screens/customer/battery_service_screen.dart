import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BatteryServiceScreen extends StatefulWidget {
  const BatteryServiceScreen({super.key});

  @override
  State<BatteryServiceScreen> createState() => _BatteryServiceScreenState();
}

class _BatteryServiceScreenState extends State<BatteryServiceScreen> {
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _garageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  TextStyle get _labelStyle => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF6B7280),
  );

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _garageController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _showSelectionDialog(String title, List<String> items, TextEditingController controller) {
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
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ...items.map((item) => ListTile(
                title: Text(item, style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  setState(() => controller.text = item);
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickGarage() async {
    final snapshot = await FirebaseFirestore.instance.collection('garages').get();
    final names = snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    _showSelectionDialog('Select Garage', names, _garageController);
  }

  Future<void> _pickVehicle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('vehicles').get();
    final vehicles = snapshot.docs.map((doc) => "${doc.data()['make']} ${doc.data()['model']} (${doc.data()['plateNumber']})").toList();
    
    if (vehicles.isEmpty) {
      vehicles.addAll(['Toyota Camry (RAC 881C)', 'Mercedes Benz (RAD 123A)']);
    }
    
    _showSelectionDialog('Select Vehicle', vehicles, _vehicleController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Battery Service',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0F172A) : const Color(0xFF1D9CE5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.battery_charging_full_outlined, size: 28, color: Color(0xFF0EA5E9)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(
                                'Battery Services',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Professional battery care for your vehicle',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _ServiceChip(
                        label: 'Battery Replacement', 
                        price: 'From Rw 45,000',
                        onTap: () {
                          setState(() => _serviceTypeController.text = 'Battery Replacement');
                        },
                      ),
                      _ServiceChip(
                        label: 'Battery Testing', 
                        price: 'From Rw 10,000',
                        onTap: () {
                          setState(() => _serviceTypeController.text = 'Battery Testing');
                        },
                      ),
                      _ServiceChip(
                        label: 'Charging System', 
                        price: 'From Rw 15,000',
                        onTap: () {
                          setState(() => _serviceTypeController.text = 'Charging System');
                        },
                      ),
                      _ServiceChip(
                        label: 'Jump Start', 
                        price: 'From Rw 5,000',
                        onTap: () {
                          setState(() => _serviceTypeController.text = 'Jump Start');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Book Battery Service',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Service Type', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_serviceTypeController, 'Select service type', onTap: () {
              _showSelectionDialog('Select Service', ['Battery Replacement', 'Battery Testing', 'Charging System', 'Jump Start'], _serviceTypeController);
            }),
            const SizedBox(height: 12),
            Text('Garage', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_garageController, 'Select a garage', onTap: _pickGarage),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date', style: _labelStyle),
                      const SizedBox(height: 8),
                      _field(_dateController, 'mm/dd/yyyy', icon: Icons.calendar_today_outlined, onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                        if (date != null) setState(() => _dateController.text = "${date.month}/${date.day}/${date.year}");
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time', style: _labelStyle),
                      const SizedBox(height: 8),
                      _field(_timeController, '--:-- --', icon: Icons.access_time_outlined, onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (time != null) setState(() => _timeController.text = time.format(context));
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Location', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_locationController, 'Where should the service be done?', icon: Icons.location_on_outlined),
            const SizedBox(height: 12),
            Text('Vehicle', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_vehicleController, 'Select your vehicle', icon: Icons.directions_car_outlined, onTap: _pickVehicle),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _bookService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9CE5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Book Service',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint, {IconData? icon, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontFamily: 'Poppins',
          fontSize: 13,
        ),
        prefixIcon: icon == null ? null : Icon(icon, size: 18, color: Theme.of(context).hintColor),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
        ),
      ),
    );
  }

  void _bookService() {
    final valid = _serviceTypeController.text.trim().isNotEmpty &&
        _garageController.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty &&
        _timeController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _vehicleController.text.trim().isNotEmpty;

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all booking fields')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Battery service booked successfully'),
        backgroundColor: Color(0xFF1D9CE5),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  final String price;
  final VoidCallback onTap;

  const _ServiceChip({required this.label, required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}