import 'package:flutter/material.dart';
import 'package:garage_guru/screens/customer/customer_shell.dart';

class EmergencyRepairScreen extends StatefulWidget {
  const EmergencyRepairScreen({super.key});

  @override
  State<EmergencyRepairScreen> createState() => _EmergencyRepairScreenState();
}

class _EmergencyRepairScreenState extends State<EmergencyRepairScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Emergency Repair',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8D4),
                  border: Border(left: BorderSide(color: Color(0xFFFF8A00), width: 3)),
                ),
                child: const Text(
                  'Emergency repairs are prioritized and will connect you with the nearest available mechanic.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFFC2410C),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Your Location', style: _labelStyle),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: _inputDecoration(
                  hint: 'Current location or address',
                  icon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: () => _locationController.text = 'Kigali, Rwanda',
                icon: const Icon(Icons.my_location_rounded, size: 18, color: Color(0xFF0D9488)),
                label: const Text(
                  'Use current location',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF0D9488),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Describe the issue', style: _labelStyle),
              const SizedBox(height: 8),
              TextField(
                controller: _issueController,
                maxLines: 4,
                decoration: _inputDecoration(
                  hint: 'What\'s happening with your car?\n(e.g: flat tire, won\'t start etc,...)',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _requestEmergencyRepair,
                  icon: const Icon(Icons.shield_outlined, color: Colors.white),
                  label: const Text(
                    'Request Emergency repair',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Emergency Contact',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.phone_outlined, color: Color(0xFF0D9488)),
                  SizedBox(width: 8),
                  Text(
                    '+250 789 123 456',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.schedule_outlined, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    '24/7 Emergency Support',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  'Average response time: 15 minutes',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        color: Color(0xFF9CA3AF),
      ),
      prefixIcon: icon == null ? null : Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFF6B00)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => CustomerShell(initialTab: index)),
          (_) => false,
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Garages'),
        BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Repairs'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }

  void _requestEmergencyRepair() {
    if (_locationController.text.trim().isEmpty || _issueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add location and issue first')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency request sent. Mechanic is being assigned.'),
        backgroundColor: Color(0xFFFF6B00),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

const TextStyle _labelStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 14,
  color: Color(0xFF111827),
);