
class UserInfoDTO {
  final String userName;
  final String birth;
  final String gender;
  final String mbti;

  UserInfoDTO({required this.userName,
                required this.birth,
                required this.gender,
                required this.mbti});

  factory UserInfoDTO.fromJson(dynamic json) {
    return UserInfoDTO(
      userName: json['userName'] as String ?? '솔스토리',
      birth: json['birth'] as String ?? '20240831',
      gender: json['gender'] as String ?? '남자',
      mbti: json['birth'] as String ?? 'INTP',
    );
  }
}

class Interest{
  final int interestNo;
  final int userNo;
  final String interestCate;

  Interest({required this.interestNo,
    required this.userNo,
    required this.interestCate});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      interestNo: json['interestNo'] ?? 0,
      userNo: json['userNo'] ?? 0,
      interestCate: json['interestCate'] ?? '정보 없음',
    );
  }
}

class Hobby{
  final int hobbyNo;
  final int userNo;
  final String HobbyCate;

  Hobby({required this.hobbyNo,
    required this.userNo,
    required this.HobbyCate});

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      hobbyNo: json['hobbyNo'] ?? 0,
      userNo: json['userNo'] ?? 0,
      HobbyCate: json['HobbyCate'] ?? '정보 없음',
    );
  }
}