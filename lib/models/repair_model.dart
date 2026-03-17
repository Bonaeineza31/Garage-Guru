enum RepairStatus { mechanicOnWay, inProgress, completed, cancelled }

class RepairUpdate {
  final DateTime timestamp;
  final String message;

  const RepairUpdate({required this.timestamp, required this.message});
}

class RepairModel {
  final String id;
  final String serviceName;
  final String vehicleMake;
  final String vehicleModel;
  final String vehiclePlate;
  final double progressPercent;
  final RepairStatus status;
  final String mechanicName;
  final String mechanicSpecialty;
  final double mechanicRating;
  final String? mechanicAvatarUrl;
  final String? serviceImageUrl;
  final String location;
  final DateTime startDate;
  final String estimatedCompletion;
  final String repairDescription;
  final double partsCost;
  final double laborCost;
  final List<RepairUpdate> updates;
  final bool isPaid;

  const RepairModel({
    required this.id,
    required this.serviceName,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.progressPercent,
    required this.status,
    required this.mechanicName,
    required this.mechanicSpecialty,
    required this.mechanicRating,
    this.mechanicAvatarUrl,
    this.serviceImageUrl,
    required this.location,
    required this.startDate,
    required this.estimatedCompletion,
    required this.repairDescription,
    required this.partsCost,
    required this.laborCost,
    required this.updates,
    this.isPaid = false,
  });

  double get totalCost => partsCost + laborCost;

  String get vehicleInfo => '$vehicleMake $vehicleModel • $vehiclePlate';

  String get statusLabel {
    switch (status) {
      case RepairStatus.mechanicOnWay:
        return 'Mechanic on way';
      case RepairStatus.inProgress:
        return 'In Progress';
      case RepairStatus.completed:
        return 'Completed';
      case RepairStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class RepairHistoryModel {
  final String id;
  final String serviceName;
  final String vehicleMake;
  final String vehicleModel;
  final String vehiclePlate;
  final DateTime date;
  final String mechanicName;
  final String location;
  final double cost;
  final DateTime nextServiceDue;

  const RepairHistoryModel({
    required this.id,
    required this.serviceName,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.date,
    required this.mechanicName,
    required this.location,
    required this.cost,
    required this.nextServiceDue,
  });

  String get vehicleInfo => '$vehicleMake $vehicleModel • $vehiclePlate';
}

class FeedbackModel {
  final String id;
  final String serviceTitle;
  final DateTime date;
  final int rating;
  final String comment;
  final String? garageResponse;

  const FeedbackModel({
    required this.id,
    required this.serviceTitle,
    required this.date,
    required this.rating,
    required this.comment,
    this.garageResponse,
  });
}
