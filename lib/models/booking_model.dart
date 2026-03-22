enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final String customerId;
  final String garageId;
  final String garageName;
  final String garageAddress;
  final String? garageImageUrl;
  final List<BookedService> services;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleYear;
  final String? vehiclePlate;
  final String? notes;
  final BookingStatus status;
  final double totalAmount;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.customerId,
    required this.garageId,
    required this.garageName,
    required this.garageAddress,
    this.garageImageUrl,
    required this.services,
    required this.scheduledDate,
    required this.scheduledTime,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.vehiclePlate,
    this.notes,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get vehicleInfo {
    final parts = [vehicleYear, vehicleMake, vehicleModel]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.join(' ');
  }
}

class BookedService {
  final String serviceId;
  final String name;
  final double price;

  const BookedService({
    required this.serviceId,
    required this.name,
    required this.price,
  });
}
