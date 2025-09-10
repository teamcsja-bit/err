
class ErrandPost {
  final String id;
  final String type; // 'offer' or 'request'
  final String place;
  final String item;
  final String userNickname;
  final DateTime eta;
  final double radiusKm;
  String status; // 'active', 'matched', 'expired'
  final DateTime createdAt;
  final DateTime expiresAt;

  ErrandPost({
    required this.id,
    required this.type,
    required this.place,
    required this.item,
    required this.userNickname,
    required this.eta,
    required this.radiusKm,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
