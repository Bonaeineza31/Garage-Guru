import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';

/// Customer "Request Repair" form (Figma: blue header, repair type, date/time, location, vehicle, issue).
class RequestRepairFormScreen extends StatefulWidget {
  final String? initialRepairType;

  const RequestRepairFormScreen({
    super.key,
    this.initialRepairType,
  });

  @override
  State<RequestRepairFormScreen> createState() => _RequestRepairFormScreenState();
}

class _RequestRepairFormScreenState extends State<RequestRepairFormScreen> {
  static const List<String> _repairTypes = [
    'Oil Change',
    'Tire Service',
    'Tire Rotation',
    'Battery Service',
    'Engine Diagnostics',
    'Brake Service',
    'Emergency',
    'Full Inspection',
    'Other',
  ];

  String? _selectedRepairType;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRepairType?.trim();
    if (initial != null &&
        initial.isNotEmpty &&
        _repairTypes.contains(initial)) {
      _selectedRepairType = initial;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _vehicleController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  // ✅ FIX 1: _labelStyle moved INSIDE the class, uses context correctly
  TextStyle get _labelStyle => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF111827),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : const Color(0xFF1D9CE5),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        // ✅ FIX 2: Removed const + Theme.of(context) from TextStyle (can't mix)
        title: const Text(
          'Request Repair',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Repair Type', style: _labelStyle),
              const SizedBox(height: 8),
              _repairTypeField(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date', style: _labelStyle),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: _dateController,
                          hint: 'mm/dd/yyyy',
                          icon: Icons.calendar_today_outlined,
                        ),
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
                        _inputField(
                          controller: _timeController,
                          hint: '--:-- --',
                          icon: Icons.access_time_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Location', style: _labelStyle),
              const SizedBox(height: 8),
              _inputField(
                controller: _locationController,
                hint: 'Where should the mechanic meet you?',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              Text('Vehicle', style: _labelStyle),
              const SizedBox(height: 8),
              _inputField(
                controller: _vehicleController,
                hint: 'Select your vehicle',
                icon: Icons.directions_car_outlined,
              ),
              const SizedBox(height: 12),
              Text('Issue Description', style: _labelStyle),
              const SizedBox(height: 8),
              _inputField(
                controller: _issueController,
                hint: 'Describe the issue with your vehicle',
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9CE5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _repairTypeField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRepairType != null &&
              _repairTypes.contains(_selectedRepairType)
          ? _selectedRepairType
          : null,
      decoration: _fieldDecoration(),
      hint: const Text(
        'Select Repair type',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Color(0xFF9CA3AF),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF9CA3AF)),
      items: _repairTypes
          .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedRepairType = v),
    );
  }

  InputDecoration _fieldDecoration({IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, size: 18, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1D9CE5), width: 1.2),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      decoration: _fieldDecoration(prefixIcon: icon).copyWith(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  void _submit() {
    final typeOk =
        _selectedRepairType != null && _selectedRepairType!.trim().isNotEmpty;
    if (!typeOk ||
        _dateController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _vehicleController.text.trim().isEmpty ||
        _issueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields first')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Repair request submitted successfully'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }
}