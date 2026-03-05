class ServiceModel {
  final String id;
  final String garageId;
  final String name;
  final String description;
  final String category;
  final double price;
  final int estimatedMinutes;
  final String? iconName;
  final bool isActive;

  const ServiceModel({
    required this.id,
    required this.garageId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.estimatedMinutes,
    this.iconName,
    this.isActive = true,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedDuration {
    if (estimatedMinutes < 60) return '$estimatedMinutes min';
    final hours = estimatedMinutes ~/ 60;
    final mins = estimatedMinutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}