import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/owned_cards_model.dart'; // 소유 카드 모델 가져오기
import 'solama_service.dart'; // SolamaService 가져오기

class StoryNew extends StatefulWidget {
  @override
  _StoryNewState createState() => _StoryNewState();
}

class _StoryNewState extends State<StoryNew> {
  final Random _random = Random();
  List<String> _selectedPersons = [];
  List<String> _selectedObjects = [];
  String _selectedPlace = '';
  final SolamaService _solamaService = SolamaService(); // SolamaService 인스턴스
  String _generatedScenario = ''; // 생성된 시나리오 저장 변수
  String _prompt = ''; // 조합된 문장 저장 변수

  List<String> _situations = [
    "사고가 나서 사람이 죽는다",
    "주인공이 비밀을 발견한다",
    "갈등이 극에 달해 결투가 벌어진다",
    "주인공이 중요한 결정을 내린다",
    "적의 계획이 드러난다",
    "주인공이 사랑에 빠진다",
    "대재앙이 발생한다",
    "주인공이 예기치 않은 도움을 받는다",
    "비밀이 밝혀진다",
    "주인공이 배신당한다",
    "위험한 여행을 떠난다",
    "주인공이 팀을 형성한다",
    "중요한 정보를 얻는다",
    "적의 함정에 빠진다",
    "주인공이 큰 성공을 거둔다",
    "위기에 처한 인물을 구한다",
    "주인공이 과거를 회상한다",
    "적과의 대화에서 중요한 정보가 나온다",
    "주인공이 희생을 감수한다",
    "사람들이 반란을 일으킨다",
    "주인공이 중요한 목표를 달성한다",
    "위험한 상황에서 탈출한다",
    "주인공이 적의 음모를 저지한다",
    "상황이 급변한다",
    "주인공이 새로운 동맹을 만난다"
  ];

  List<String> _endings = [
    "주인공이 세상을 구합니다",
    "주인공이 악당을 물리칩니다",
    "모든 갈등이 해결됩니다",
    "주인공이 사랑을 얻습니다",
    "주인공이 예상치 못한 희생을 치릅니다",
    "적의 계획이 실패합니다",
    "주인공이 새로운 시작을 맞이합니다",
    "주인공이 자신을 찾습니다",
    "주인공이 중요한 교훈을 배웁니다",
    "모든 인물이 행복하게 살아갑니다",
    "주인공이 복수를 완수합니다",
    "갈등의 원인이 밝혀집니다",
    "주인공이 꿈을 이룹니다",
    "주인공이 권력을 얻습니다",
    "모든 인물이 화해합니다",
    "주인공이 자신의 과거를 정리합니다",
    "적이 교훈을 얻고 개과천선합니다",
    "주인공이 독립적인 존재가 됩니다",
    "주인공이 친구들과 함께 새 삶을 시작합니다",
    "주인공이 숨겨진 진실을 밝혀냅니다",
    "주인공이 큰 상을 받습니다",
    "모든 문제들이 해결됩니다",
    "주인공이 역사에 길이 남는 업적을 이룹니다",
    "주인공이 내면의 평화를 찾습니다",
    "주인공이 고독한 삶을 살아가게 됩니다",
    "미래가 불확실하게 열려 있습니다",
    "주인공이 비극적인 결말을 맞이합니다"
  ];

  List<String> _roles = [
    "주인공", "여주인공", "경쟁자", "배신자", "조력자", "멘토", "악당",
    "히어로", "반란군", "유머러스한 조연", "여신", "영웅", "희생자",
    "잠입자", "정보 제공자", "중재자", "복수자", "악녀", "지혜자",
    "전략가", "혁명가", "연인", "탐정", "조연", "이방인"
  ];

  List<String> _personalities = [
    "착한", "똑똑한", "코드를 잘하는", "창의적인", "성실한", "호기심이 많은",
    "활발한", "리더십이 있는", "인내심이 강한", "유머가 있는", "협동적인",
    "냉철한", "사교적인", "논리적인", "신중한", "겸손한", "성격이 급한",
    "책임감이 강한", "진지한", "소심한", "다정한", "대담한", "정직한",
    "편안한", "정열적인"
  ];

  List<String> _objectPurposes = [
    "갈등이 생기는 원인이 된다",
    "문제가 해결되는데 결정적인 역할을 한다",
    "주인공의 목표를 달성하는 데 사용된다",
    "중요한 단서를 제공한다",
    "주인공의 성장에 기여한다",
    "스토리의 전개를 이끈다",
    "갈등을 해결하는 열쇠가 된다",
    "주인공의 상징적인 존재가 된다",
    "스토리의 클라이맥스를 형성한다",
    "감정적인 터닝 포인트를 만든다",
    "주인공의 결정을 촉발시킨다",
    "기타 인물들과의 관계를 변화시킨다",
    "스토리의 배경을 형성한다",
    "주인공의 도전에 중요한 역할을 한다",
    "주인공의 과거를 드러낸다",
    "스토리의 시작과 끝을 연결한다",
    "상황의 긴장감을 높인다",
    "주인공의 행동을 유도한다",
    "문제를 복잡하게 만든다",
    "주인공의 목표를 방해한다",
    "주인공의 승리를 확립한다",
    "스토리의 분위기를 조성한다",
    "주인공의 희망을 상징한다",
    "스토리의 전환점을 만든다"
  ];

  void _generateScenario() async {
    if (_selectedPersons.isEmpty || _selectedObjects.isEmpty || _selectedPlace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 카드를 선택해 주세요.')),
      );
      return;
    }

    List<String> sentences = [];
    // 역할 및 성격 랜덤 선택
    for (var person in _selectedPersons) {
      String role = _roles[_random.nextInt(_roles.length)];
      String personality = _personalities[_random.nextInt(_personalities.length)];
      sentences.add("$role 역할로 $person이 나오고, $personality 사람이야.");
    }

    // 물건의 목적 랜덤 선택
    for (var object in _selectedObjects) {
      String purpose = _objectPurposes[_random.nextInt(_objectPurposes.length)];
      sentences.add("$object이 $purpose");
    }

    // 장소를 배경으로 설정
    sentences.add("$_selectedPlace를 배경으로 해줘");

    // 상황 랜덤 선택
    int numSituations = _random.nextInt(4) + 1;
    for (var i = 0; i < numSituations; i++) {
      String situation = _situations[_random.nextInt(_situations.length)];
      sentences.add("$situation");
    }

    // 결말 랜덤 선택
    String ending = _endings[_random.nextInt(_endings.length)];
    sentences.add("끝에는 $ending 결말로 마무리해줘");

    // 최종 시나리오 생성
    _prompt = "이야기를 만들어줘.\n";
    _prompt += sentences.join('\n');
    _prompt += "\n이야기를 만들어줘.\n소설 형식으로 변환해서 작성해줘";

    // 사용된 카드 즉시 삭제
    final ownedCardsModel = Provider.of<OwnedCardsModel>(context, listen: false);
    for (var person in _selectedPersons) {
      ownedCardsModel.removeCard(person, 'person');
    }
    for (var object in _selectedObjects) {
      ownedCardsModel.removeCard(object, 'object');
    }
    ownedCardsModel.removeCard(_selectedPlace, 'place');

    setState(() {
      _selectedPersons.clear();
      _selectedObjects.clear();
      _selectedPlace = '';
      _generatedScenario = '조합된 문장을 시나리오 생성기에 넣었습니다:\n$_prompt';
    });

    // 시나리오를 Sollama로 전송
    try {
      String generatedScenario = await _solamaService.generateScenario(_prompt);

      // 시나리오 생성 결과를 화면에 추가
      setState(() {
        _generatedScenario += '\n\n생성된 시나리오:\n$generatedScenario';
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('시나리오 생성 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownedCardsModel = Provider.of<OwnedCardsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('새 스토리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('인물 카드'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ownedCardsModel.ownedPersonCards.map((card) => ChoiceChip(
                label: Text(card),
                selected: _selectedPersons.contains(card),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedPersons.length < 4) {
                        _selectedPersons.add(card);
                      }
                    } else {
                      _selectedPersons.remove(card);
                    }
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 16.0),
            Text('물건 카드'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ownedCardsModel.ownedObjectCards.map((card) => ChoiceChip(
                label: Text(card),
                selected: _selectedObjects.contains(card),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedObjects.length < 4) {
                        _selectedObjects.add(card);
                      }
                    } else {
                      _selectedObjects.remove(card);
                    }
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 16.0),
            Text('장소 카드'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ownedCardsModel.ownedPlaceCards.map((card) => ChoiceChip(
                label: Text(card),
                selected: _selectedPlace == card,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedPlace = selected ? card : '';
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _generateScenario,
              child: Text('시나리오 생성'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_generatedScenario),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
