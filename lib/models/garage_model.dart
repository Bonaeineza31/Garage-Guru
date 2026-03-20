class GarageModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? email;
  final String? website;
  final String coverImageUrl;
  final List<String> galleryImages;
  final List<String> services;
  final List<String> specializations;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final Map<String, WorkingHours> workingHours;
  final double distanceKm;

  const GarageModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.email,
    this.website,
    required this.coverImageUrl,
    this.galleryImages = const [],
    this.services = const [],
    this.specializations = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.workingHours = const {},
    this.distanceKm = 0.0,
  });

  bool get isOpen {
    final now = DateTime.now();
    final dayNames = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday'
    ];
    final today = dayNames[now.weekday - 1];
    final hours = workingHours[today];
    if (hours == null || hours.isClosed) return false;
    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes >= hours.openMinutes && currentMinutes <= hours.closeMinutes;
  }
}

class WorkingHours {
  final String open;
  final String close;
  final bool isClosed;

  const WorkingHours({
    required this.open,
    required this.close,
    this.isClosed = false,
  });

  int get openMinutes => _toMinutes(open);
  int get closeMinutes => _toMinutes(close);

  int _toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}