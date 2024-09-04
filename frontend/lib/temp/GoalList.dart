import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Scenario/models/key_model.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  // 저축 및 지출 관련 챌린지 리스트와 각 챌린지에 대한 보상
  final List<Map<String, dynamic>> _savingGoals = [
    {'title': '저축 10,000원 모으기', 'reward': 15, 'completed': false},
    {'title': '저축 20,000원 모으기', 'reward': 25, 'completed': false},
    {'title': '저축 50,000원 모으기', 'reward': 35, 'completed': false},
    {'title': '저축 100,000원 모으기', 'reward': 50, 'completed': false},
  ];

  final List<Map<String, dynamic>> _spendingGoals = [
    {'title': '월간 지출 10% 줄이기', 'reward': 20, 'completed': false},
    {'title': '월간 지출 20% 줄이기', 'reward': 30, 'completed': false},
    {'title': '불필요한 구독 서비스 취소하기', 'reward': 10, 'completed': false},
    {'title': '자동차 유지비 절감하기', 'reward': 15, 'completed': false},
    {'title': '외식 비용 50% 줄이기', 'reward': 25, 'completed': false},
    {'title': '다이어트 식품 구매비용 절감하기', 'reward': 40, 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    final keyModel = Provider.of<KeyModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '선물함',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '열쇠: ${keyModel.key}',
              style: TextStyle(fontSize: 16, color: Colors.lightBlue[100]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 저축 목표 섹션
            _buildSectionTitle('저축 목표'),
            ..._savingGoals
                .map((goal) => _buildGoalCard(goal, keyModel))
                .toList(),
            SizedBox(height: 20),
            // 지출 목표 섹션
            _buildSectionTitle('지출 목표'),
            ..._spendingGoals
                .map((goal) => _buildGoalCard(goal, keyModel))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, KeyModel keyModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[200]!,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            goal['title'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '보상: ${goal['reward']} 열쇠',
            style: TextStyle(fontSize: 16, color: Colors.blue[700]),
          ),
          trailing: ElevatedButton(
            onPressed: goal['completed']
                ? null
                : () {
                    // 챌린지 완료 처리
                    keyModel.addKey(goal['reward']);
                    setState(() {
                      goal['completed'] = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${goal['reward']} 열쇠를 받았습니다!'),
                      ),
                    );
                  },
            child: Text(goal['completed'] ? '완료됨' : '보상 받기'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  goal['completed'] ? Colors.grey : Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
