import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled1/Scenario/models/story_data.dart';

class StoryDetailPage extends StatefulWidget {
  final Story story;

  StoryDetailPage({required this.story});

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  double _fontSize = 18.0; // 초기 글자 크기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/images/backgroundBBK.svg',
            fit: BoxFit.cover,
          ),
           Positioned(
        top: 40, // 상단으로부터의 거리
        left: 1, // 왼쪽으로부터의 거리
        child: RawMaterialButton(
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
          elevation: 2.0,
          fillColor: Colors.white.withOpacity(0.3),
          child: Icon(
            Icons.arrow_back,
            size: 24.0,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
          Positioned.fill(
            top: 0,
            child: SvgPicture.asset(
              'assets/images/star.svg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      widget.story.title,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'AppleSDGothicNeo',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        Share.share(
                            '${widget.story.title}\n\n${widget.story.content}');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.story.content,
                        style: TextStyle(
                          fontSize: _fontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16), // 여백 추가
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _fontSize = (_fontSize > 10)
                                ? _fontSize - 2
                                : _fontSize; // 최소 글자 크기 제한
                          });
                        },
                      ),
                      Text(
                        'A',
                        style: TextStyle(
                          fontSize: _fontSize,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _fontSize = (_fontSize < 30)
                                ? _fontSize + 2
                                : _fontSize; // 최대 글자 크기 제한
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
