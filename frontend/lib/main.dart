import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/GoalList/create_useraccount.dart';
import 'package:untitled1/Login/FindPW.dart';
import 'package:untitled1/Login/Register.dart';
import 'package:untitled1/Scenario/models/key_model.dart';
import 'package:untitled1/Scenario/models/owned_cards_model.dart';
import 'package:untitled1/Scenario/models/story_data.dart';
import 'package:untitled1/Login/Login.dart';
import 'package:untitled1/MainPage/MainPage.dart';
import 'package:untitled1/Scenario/story_main.dart';
import 'package:untitled1/Scenario/story_new.dart';
import 'package:untitled1/UserProfile/FinancialAnaly/FinancialAnaly.dart';
import 'package:untitled1/UserProfile/UserProfile.dart';
import 'package:untitled1/GoalList/GoalList.dart';
import 'package:untitled1/Product/Product.dart';
import 'package:untitled1/setting.dart'; // 추가된 import
import 'package:untitled1/GoalList/user_challenge_list.dart';
import 'package:untitled1/GoalList/transfer_onewon.dart';
import 'package:untitled1/GoalList/verify_onewon.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => KeyModel()),
        ChangeNotifierProvider(create: (context) => OwnedCardsModel()),
        ChangeNotifierProvider(create: (context) => StoryDataModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스토리 생성기',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF4068FF,
          {
            50: Color(0xFFE5E9FF),
            100: Color(0xFFB8C7FF),
            200: Color(0xFF8AA3FF),
            300: Color(0xFF5C7FFF),
            400: Color(0xFF4068FF), // Main Color
            500: Color(0xFF2E53DB),
            600: Color(0xFF2341B2),
            700: Color(0xFF192F89),
            800: Color(0xFF101D60),
            900: Color(0xFF080C37),
          },
        ),
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 232, 232, 232), // 배경색 변경

        // AppBar 테마 설정
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF4068FF), // 상단 바 색상 설정
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            fontSize: 20,
            color: const Color(0xFFFFFFFF), // 글씨 색상 설정 (밝은 색)
          ),
        ),

        // 버튼 테마 설정
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // 버튼 텍스트 색상
            backgroundColor: const Color.fromRGBO(64, 104, 255, 1), // 버튼 배경색 설정
            textStyle: TextStyle(
              fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
              color: Colors.white,
            ),
          ),
        ),

        // 텍스트 필드 테마 설정
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF), // 텍스트박스 배경색 설정
          hintStyle: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFFD9D9D9), // 힌트 텍스트 색상 (밝은 색)
          ),
          labelStyle: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFF474747), // 라벨 텍스트 색상 (어두운 색)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
        ),

        // Chip 테마 설정
        chipTheme: ChipThemeData(
          backgroundColor:
              const Color.fromARGB(255, 231, 231, 231), // Chip 배경색 설정
          selectedColor: const Color(0xFF1F14FA), // 선택된 Chip 색상
          secondarySelectedColor: const Color(0xFF1F14FA),
          labelStyle: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFF474747), // Chip 텍스트 색상 (밝은 색)
          ),
          secondaryLabelStyle: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFFFFFFFF), // 선택된 Chip 텍스트 색상 (밝은 색)
          ),
          brightness: Brightness.light,
          shape: StadiumBorder(
            side: BorderSide(
              color: Colors.transparent, // 테두리를 투명하게 설정
            ),
          ),
          elevation: 4, // 그림자 추가
        ),

        // 기본 텍스트 테마 설정
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFF474747), // 기본 텍스트 색상 (어두운 색)
          ),
          bodyMedium: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFF474747), // 기본 텍스트 색상 (어두운 색)
          ),
          displayLarge: TextStyle(
            fontFamily: 'AppleSDGothicNeoB', // 폰트 설정
            color: const Color(0xFFD9D9D9), // 제목 텍스트 색상 (밝은 색)
          ),
        ),
      ),
      home: Login(
      ),
      routes: {
        //'/main': (context) => MainPage(),
        '/goalList': (context) => GoalListPage(
              userNo: 1,
            ),
        '/challenges': (context) => ChallengeListPage(
              userNo: 1,
            ),
        '/login': (context) => Login(),
        '/product': (context) => Product(),
        '/story': (context) => StoryMain(),
        '/setting': (context) => SettingPage(),
        '/register': (context) => Register(),
        '/findPW': (context) => FindPW(), // 추가된 경로
        '/transfer/one-won': (context) => TransferOneWonPage(),
        '/verify/one-won': (context) => VerifyOneWonPage(),
      },
    );
  }
}
