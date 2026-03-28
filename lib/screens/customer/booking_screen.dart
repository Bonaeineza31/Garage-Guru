import 'package:flutter/material.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedVehicle;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  final List<String> _vehicles = ['Toyota Corolla - ABC 123', 'Honda Civic - XYZ 789'];
  final List<String> _serviceTypes = ['Full inspection', 'Oil Change', 'Engine Diagnostics', 'Brake Pad Replacement', 'Tire Replacement'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Garage'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),
              const Text('Book Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              _buildInputLabel('Date'),
              _buildDateInput(),
              const SizedBox(height: 16),
              
              _buildInputLabel('Time'),
              _buildTimeInput(),
              const SizedBox(height: 16),
              
              _buildInputLabel('Vehicle'),
              _buildDropdown('Select your vehicle', _selectedVehicle, _vehicles, (val) => setState(() => _selectedVehicle = val)),
              const SizedBox(height: 16),
              
              _buildInputLabel('Service Type'),
              _buildDropdown('Select service type', _selectedService, _serviceTypes, (val) => setState(() => _selectedService = val)),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 32),
              const Text('Available Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildAvailableService('Engine Diagnostics', 'Full computer diagnostics', 'Frw 25,000'),
              _buildAvailableService('Brake Pad Replacement', 'All 4 wheels', 'Frw 45,000'),
              _buildAvailableService('Oil Change', 'Includes filter', 'Frw 30,000'),
              _buildAvailableService('Tire Replacement', 'Per tire', 'Frw 20,000'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.garage.coverImageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.garage.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.garage.rating} (${widget.garage.reviewCount} reviews)',
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${widget.garage.distanceKm}km away • ${widget.garage.address.split(',').last.trim()}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildDateInput() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'mm/dd/yyyy',
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.divider)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: _selectDate,
      validator: (val) => val == null || val.isEmpty ? 'Select a date' : null,
    );
  }

  Widget _buildTimeInput() {
    return TextFormField(
      controller: _timeController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: '-- : -- --',
        suffixIcon: const Icon(Icons.access_time_outlined, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.divider)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: _selectTime,
      validator: (val) => val == null || val.isEmpty ? 'Select a time' : null,
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(fontSize: 14)),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.divider)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Please select an option' : null,
    );
  }

  Widget _buildAvailableService(String name, String desc, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(desc, style: AppTextStyles.caption),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _validateAndConfirm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmed'),
          content: const Text('Your booking has been successfully scheduled.'),
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
}
