class ErrandRequest {
  final String id;
  final String description;
  final double distanceKm;
  final bool isUrgent;
  final String requester;
  final DateTime createdAt;
  final DateTime expiresAt;
  String status; // 'active', 'accepted', 'fulfilled', 'expired'

  ErrandRequest({
    required this.id,
    required this.description,
    required this.distanceKm,
    required this.isUrgent,
    required this.requester,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
