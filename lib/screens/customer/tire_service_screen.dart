import 'package:flutter/material.dart';

class TireServiceScreen extends StatefulWidget {
  const TireServiceScreen({super.key});

  @override
  State<TireServiceScreen> createState() => _TireServiceScreenState();
}

class _TireServiceScreenState extends State<TireServiceScreen> {
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _garageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9CE5),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Tire Service',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tire Services',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Professional tire care for your vehicle',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _ServiceChip(label: 'Tire Replacement', price: 'From Rw 20,000'),
                _ServiceChip(label: 'Tire Rotation', price: 'From Rw 15,000'),
                _ServiceChip(label: 'Wheel Alignment', price: 'From Rw 25,000'),
                _ServiceChip(label: 'Tire Pressure', price: 'From Rw 5,000'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Book Tire Service',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 12),
            const Text('Service Type', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_serviceTypeController, 'Select service type'),
            const SizedBox(height: 12),
            const Text('Garage', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_garageController, 'Select a garage'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date', style: _labelStyle),
                      const SizedBox(height: 8),
                      _field(_dateController, 'mm/dd/yyyy', icon: Icons.calendar_today_outlined),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time', style: _labelStyle),
                      const SizedBox(height: 8),
                      _field(_timeController, '--:-- --', icon: Icons.access_time_outlined),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Location', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_locationController, 'Where should the service be done?', icon: Icons.location_on_outlined),
            const SizedBox(height: 12),
            const Text('Vehicle', style: _labelStyle),
            const SizedBox(height: 8),
            _field(_vehicleController, 'Select your vehicle', icon: Icons.directions_car_outlined),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _bookService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9CE5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Book Service',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
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

  Widget _field(TextEditingController controller, String hint, {IconData? icon}) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontFamily: 'Poppins',
          fontSize: 13,
        ),
        prefixIcon: icon == null ? null : Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1D9CE5)),
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
        content: Text('Tire service booked successfully'),
        backgroundColor: Color(0xFF1D9CE5),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  final String price;

  const _ServiceChip({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }
}

const TextStyle _labelStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  fontSize: 13,
  color: Color(0xFF111827),
);
