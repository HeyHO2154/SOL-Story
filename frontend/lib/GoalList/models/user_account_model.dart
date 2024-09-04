class UserAccount {
  final String userId;
  final String username;
  final String institutionCode;
  final String userKey;
  final String created;
  final String modified;

  UserAccount({
    required this.userId,
    required this.username,
    required this.institutionCode,
    required this.userKey,
    required this.created,
    required this.modified,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      userId: json['userId'],
      username: json['username'],
      institutionCode: json['institutionCode'],
      userKey: json['userKey'],
      created: json['created'],
      modified: json['modified'],
    );
  }
}