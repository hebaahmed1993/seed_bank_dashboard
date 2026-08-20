class ActivityLogModel {
  final String id;
  final String adminId;
  final String targetUserId;
  final String activityTypeId;
  final String description;
  final DateTime? timestamp;

  const ActivityLogModel({
    required this.id,
    required this.adminId,
    required this.targetUserId,
    required this.activityTypeId,
    required this.description,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adminId': adminId,
      'targetUserId': targetUserId,
      'activityTypeId': activityTypeId,
      'description': description,
      'timestamp': timestamp,
    };
  }
}

enum ActivityType {
  userCreate('USER_CREATE'),
  userUpdate('USER_UPDATE'),
  userBlock('USER_BLOCK'),
  userUnblock('USER_UNBLOCK'),
  userRoleUpdate('USER_ROLE_UPDATE');

  final String value;
  const ActivityType(this.value);

  static ActivityType fromValue(String value) {
    return ActivityType.values.firstWhere(
          (e) => e.value == value,
      orElse: () => ActivityType.userUpdate,
    );
  }
}