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
  final bool isFavorite;

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
    this.isFavorite = false,
  });

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
    Map<String, WorkingHours>? workingHours,
    double? distanceKm,
    bool? isFavorite,
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
      workingHours: workingHours ?? this.workingHours,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory GarageModel.fromMap(Map<String, dynamic> map, String docId) {
    return GarageModel(
      id: docId,
      ownerId: map['ownerId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      latitude: num.tryParse(map['latitude']?.toString() ?? '0')?.toDouble() ?? 0.0,
      longitude: num.tryParse(map['longitude']?.toString() ?? '0')?.toDouble() ?? 0.0,
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      website: map['website']?.toString(),
      coverImageUrl: map['coverImageUrl']?.toString() ?? 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=800',
      rating: num.tryParse(map['rating']?.toString() ?? '0')?.toDouble() ?? 0.0,
      reviewCount: int.tryParse(map['reviewCount']?.toString() ?? '0') ?? 0,
      isVerified: map['isVerified'] == true,
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