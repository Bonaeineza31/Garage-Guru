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
  final bool isFavorite;
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
    this.isFavorite = false,
    this.workingHours = const {},
    this.distanceKm = 0.0,
  });

  factory GarageModel.fromMap(Map<String, dynamic> map, String docId) {
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    bool safeBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      return false;
    }

    return GarageModel(
      id: docId,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      latitude: safeDouble(map['latitude']),
      longitude: safeDouble(map['longitude']),
      phone: map['phone'] ?? '',
      email: map['email'],
      website: map['website'],
      coverImageUrl: map['coverImageUrl'] ?? 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=800',
      rating: safeDouble(map['rating']),
      reviewCount: safeInt(map['reviewCount']),
      isVerified: safeBool(map['isVerified']),
      isFavorite: safeBool(map['isFavorite']),
      services: List<String>.from(map['services'] ?? []),
      galleryImages: List<String>.from(map['galleryImages'] ?? []),
      distanceKm: safeDouble(map['distanceKm']),
    );
  }

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

  GarageModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    String? coverImageUrl,
    List<String>? galleryImages,
    List<String>? services,
    List<String>? specializations,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    bool? isFavorite,
    Map<String, WorkingHours>? workingHours,
    double? distanceKm,
  }) {
    return GarageModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      galleryImages: galleryImages ?? this.galleryImages,
      services: services ?? this.services,
      specializations: specializations ?? this.specializations,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      workingHours: workingHours ?? this.workingHours,
      distanceKm: distanceKm ?? this.distanceKm,
    );
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
