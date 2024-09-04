import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/UserProfile/user_info_form_screen.dart';
import 'package:untitled1/UserProfile/UserProfile.dart';
import 'package:untitled1/UserProfile/userInfoCheck.dart';
import 'package:untitled1/GoalList/GoalList.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 import

class MainPage extends StatefulWidget {
  final int userNo;

  MainPage({required this.userNo});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SVG 배경 이미지 설정
          SvgPicture.asset(
            'assets/images/background.svg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // 기본 배경을 꽉 채우도록 설정
          ),
          // 정적인 SVG 구름 이미지 설정
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/cloud1.svg',
              width: 1200,
              height: 800,
              fit: BoxFit.contain, // 구름 이미지를 화면 전체에 걸쳐 표시
            ),
          ),
          // 상단 중앙에 로고 배치
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 200.0, // 로고의 너비 설정
                height: 200.0, // 로고의 높이 설정
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // 좌우 여백 추가
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 420),
                  _buildIconButton(context, Icons.book, '시나리오 감상', '/story'),
                  SizedBox(height: 5),
                  _buildIconButton(context, Icons.list, '목표 관리', '/goalList'),
                  SizedBox(height: 5),
                  _buildIconButton(
                      context, Icons.person, '사용자 프로필', '/userProfile'),
                  SizedBox(height: 5),
                  _buildIconButton(
                      context, Icons.card_giftcard, '선물함', '/product'),
                ],
              ),
            ),
          ),
          // 오른쪽 상단에 설정 아이콘 배치
          Positioned(
            top: 20,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ),
          // 하단 중앙에 로그아웃 텍스트 버튼 배치
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 82, 82, 82),
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, String text, String routeName) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () async {
          // userNo에 따라 checkFirstRun 함수를 호출하여 결정
          if (routeName == '/userProfile') {
            bool isFirstRun = await checkFirstRun(widget.userNo);
            if (isFirstRun) {
              // 처음 로그인한 경우 UserInfoFormScreen으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserInfoFormScreen(userNo: widget.userNo),
                ),
              );
            } else {
              // 이미 로그인 정보가 있는 경우 UserProfile으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfile(userNo: widget.userNo), // userNo를 전달
                ),
              );
            }
          } else if (routeName == '/goalList') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GoalListPage(userNo: widget.userNo), // userNo를 전달
              ),
            );
          } else {
            Navigator.pushNamed(context, routeName);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: 14), // 높이를 늘리기 위해 패딩 조정
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 250, 250, 250)!,
                const Color.fromARGB(255, 255, 255, 255)!
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 35, color: const Color.fromRGBO(64, 104, 255, 1)),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 80, 80, 80),
                    shadows: [],
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
