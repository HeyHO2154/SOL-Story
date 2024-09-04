import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/key_model.dart';
import 'story_new.dart';
import 'story_load.dart';
import 'story_kard_own.dart';
import 'story_kard_shop.dart';
import 'story_own.dart';

class StoryMain extends StatefulWidget {
  @override
  _StoryMainState createState() => _StoryMainState();
}

class _StoryMainState extends State<StoryMain> {
  @override
  Widget build(BuildContext context) {
    final keyModel = Provider.of<KeyModel>(context);

    int scoreAchievement = 40;
    int scoreAnalysis = 60;
    int storyLoadKeys = (3 * ((scoreAchievement + scoreAnalysis) / 2)).toInt();
    int storyNewKeys = 100;

    void _checkAndNavigate(int requiredKeys, Widget page) {
      if (keyModel.key >= requiredKeys) {
        keyModel.useKey(requiredKeys);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('열쇠가 부족합니다'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('메인 페이지')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('당신의 금융 상태는 $scoreAchievement 점 입니다.'),
            Text('당신의 금융 경향은 $scoreAnalysis 점 입니다.'),
            Text('종합적으로 이번 스토리 생성시 ${((scoreAchievement + scoreAnalysis) / 2).toStringAsFixed(0)}%의 행운을 가집니다.'),
            Text('(보유중인 열쇠량 ${keyModel.key} 개)'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkAndNavigate(
                storyNewKeys,
                StoryNew(),
              ),
              child: Text('Story_New (${storyNewKeys}개 열쇠 사용)'),
            ),
            ElevatedButton(
              onPressed: () => _checkAndNavigate(
                storyLoadKeys,
                StoryLoad(),
              ),
              child: Text('Story_Load (${storyLoadKeys}개 열쇠 사용)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoryKardOwn()),
              ),
              child: Text('Story_Kard_Own'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoryKardShop()),
              ),
              child: Text('Story_Kard_Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoryOwn()),
              ),
              child: Text('Story_Own'),
            ),
          ],
        ),
      ),
    );
  }
}
