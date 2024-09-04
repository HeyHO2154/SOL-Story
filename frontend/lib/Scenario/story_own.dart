import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled1/Scenario/models/story_data.dart';
import 'StoryDetailPage.dart';

class StoryOwn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storyDataModel = Provider.of<StoryDataModel>(context);

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
                Text(
                  '저장된 스토리',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: storyDataModel.stories.isEmpty
                      ? Center(
                          child: Text(
                            '저장된 스토리가 없습니다.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: storyDataModel.stories.length,
                          itemBuilder: (context, index) {
                            final story = storyDataModel.stories[index];
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Color(0xFF243B55),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  story.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                leading: IconButton(
                                  icon: Icon(Icons.share, color: Colors.blue),
                                  onPressed: () {
                                    Share.share(
                                        '${story.title}\n\n${story.content}');
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StoryDetailPage(story: story),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        context, storyDataModel, index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, StoryDataModel storyDataModel, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF243B55),
          title: Text('스토리 삭제', style: TextStyle(color: Colors.white)),
          content:
              Text('이 스토리를 삭제하시겠습니까?', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                storyDataModel.removeStory(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TestSharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Share.share('Test message');
              },
              child: Text('Share Test Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
