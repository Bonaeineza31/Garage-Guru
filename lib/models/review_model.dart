class ReviewModel {
  final String id;
  final String garageId;
  final String customerId;
  final String customerName;
  final String? customerImageUrl;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final String? reply;
  final DateTime? replyDate;

  const ReviewModel({
    required this.id,
    required this.garageId,
    required this.customerId,
    required this.customerName,
    this.customerImageUrl,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.reply,
    this.replyDate,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
