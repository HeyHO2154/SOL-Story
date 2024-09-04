import 'package:flutter/material.dart';

class StoryLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('스토리 불러오기')),
      body: Center(
        child: Text('현재 작성중인 스토리를 불러옵니다.'),
      ),
    );
  }
}
