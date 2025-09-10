
class UserAction {
  final String requestId;
  final String userId;
  final String actionType; // 'accept', 'chat', 'delivered'
  final DateTime timestamp;

  UserAction({
    required this.requestId,
    required this.userId,
    required this.actionType,
    required this.timestamp,
  });
}
