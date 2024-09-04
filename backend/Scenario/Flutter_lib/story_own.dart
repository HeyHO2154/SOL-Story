import 'package:flutter/material.dart';

class StoryOwn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('저장된 스토리')),
      body: Center(
        child: Text('저장된 스토리 목록을 보여줍니다.'),
      ),
    );
  }
}
