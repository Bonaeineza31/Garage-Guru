class VehicleModel {
  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final String? plateNumber;
  final String? imageUrl;
  final DateTime? nextServiceDate;

  const VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    this.plateNumber,
    this.imageUrl,
    this.nextServiceDate,
  });

  String get fullName => '$make $model';

  VehicleModel copyWith({
    String? id,
    String? make,
    String? model,
    int? year,
    String? color,
    String? plateNumber,
    String? imageUrl,
    DateTime? nextServiceDate,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      plateNumber: plateNumber ?? this.plateNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'plateNumber': plateNumber,
      'imageUrl': imageUrl,
      'nextServiceDate': nextServiceDate?.toIso8601String(),
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] as String,
      make: map['make'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      color: map['color'] as String,
      plateNumber: map['plateNumber'] as String?,
      imageUrl: map['imageUrl'] as String?,
      nextServiceDate: map['nextServiceDate'] != null
          ? DateTime.parse(map['nextServiceDate'] as String)
          : null,
    );
  }
}