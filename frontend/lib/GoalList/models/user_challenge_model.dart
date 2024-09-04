import 'package:intl/intl.dart';

class UserChallenge {
  final int challengeType; // 챌린지 타입 (예: 저축, 지출)
  final String category; // 카테고리 (예: 식비, 저축 등)
  final int days; // 챌린지 기간
  final String challengeName; // 챌린지 이름
  final int rewardKeys; // 보상 열쇠
  final DateTime assignedDate; // 할당 날짜
  final DateTime completeDate; // 완료 날짜
  final List<String> top3Category;

  UserChallenge({
    required this.challengeType,
    required this.category,
    required this.days,
    required this.challengeName,
    required this.rewardKeys,
    required this.assignedDate,
    required this.completeDate,
    required this.top3Category,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
      challengeType: json['challengeType'],
      category: json['category'],
      days: json['days'],
      challengeName: json['challengeName'],
      rewardKeys: json['rewardKeys'],
      assignedDate: DateFormat('yy-MM-dd').parse(json['assignedDate']),
      completeDate: DateFormat('yy-MM-dd').parse(json['completeDate']),
      top3Category: List<String>.from(json['top3Category']),
    );
  }
  //완료 비율 계산 메서드
  double getCompletionPercentage() {
    final DateTime now = DateTime.now();
    final Duration totalDuration = completeDate.difference(assignedDate);
    final Duration elapsedDuration = now.difference(assignedDate);
    if (elapsedDuration.inDays >= totalDuration.inDays) {
      return 1.0; // 100% 완료
    } else if (elapsedDuration.inDays <= 0) {
      return 0.0; // 0% 완료
    } else {
      return elapsedDuration.inDays / totalDuration.inDays;
    }
  }
}
