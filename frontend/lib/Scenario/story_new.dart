import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Scenario/solama_service.dart';
import 'models/owned_cards_model.dart'; // 소유 카드 모델 가져오기
import 'models/key_model.dart'; // KeyModel 가져오기
import 'models/story_data.dart'; // 데이터 목록 가져오기
import 'story_own.dart'; // StoryOwn 페이지 가져오기

class StoryNew extends StatefulWidget {
  @override
  _StoryNewState createState() => _StoryNewState();
}

class _StoryNewState extends State<StoryNew> {
  double _fontSize = 16.0;
  final Random _random = Random();
  List<String> _selectedPersons = [];
  List<String> _selectedObjects = [];
  String _selectedPlace = '';
  final SolamaService _solamaService = SolamaService();
  String _generatedScenario = '';
  String _prompt = '';

  final List<String> _questions = [
    "신한은행의 본사는 서울특별시에 위치해 있다. (O/X)",
    "신한은행은 1900년에 설립되었다. (O/X)",
    "신한은행의 주요 인터넷 뱅킹 서비스 이름은 '신한쏠'이다. (O/X)",
    "신한은행의 공식 웹사이트 주소는 www.shinhan.co.kr이다. (O/X)",
    "신한은행의 대표적인 신용카드 브랜드 중 하나는 '신한카드'이다. (O/X)",
    "신한은행의 모바일 뱅킹 앱 이름은 '신한큐'이다. (O/X)",
    "신한은행의 외환 서비스에서 제공하는 주요 통화는 한국 원이다. (O/X)",
    "신한은행의 주요 기업 고객 서비스 이름은 '신한기업금융'이다. (O/X)",
    "신한은행이 최근 인수합병한 회사 중 하나는 '삼성생명'이다. (O/X)",
    "신한은행의 공식 슬로건은 'Global Top Tier Bank'이다. (O/X)",
    "신한은행은 대한민국에서 가장 오래된 은행이다. (O/X)",
    "신한은행은 글로벌 은행 네트워크를 갖추고 있다. (O/X)",
    "신한은행의 신용카드 중 하나는 '신한리워드카드'이다. (O/X)",
    "신한은행의 모바일 뱅킹 앱은 '신한뱅크'로도 알려져 있다. (O/X)",
    "신한은행은 최근에 핀테크 스타트업을 인수했다. (O/X)",
    "신한은행의 주요 외환 거래 통화 중 하나는 중국 위안이다. (O/X)",
    "신한은행의 고객 서비스는 24시간 운영된다. (O/X)",
    "신한은행은 주택담보대출을 제공하지 않는다. (O/X)",
    "신한은행은 최근에 블록체인 기술을 도입했다. (O/X)",
    "신한은행은 CSR(기업의 사회적 책임) 활동을 적극적으로 한다. (O/X)"
  ];

  final List<String> _answers = [
    "O",
    "X",
    "O",
    "X",
    "O",
    "X",
    "X",
    "O",
    "X",
    "O",
    "X",
    "O",
    "X",
    "X",
    "X",
    "O",
    "X",
    "O",
    "X",
    "O"
  ];

  String? _currentQuestion;
  String? _currentAnswer;
  bool _isQuizAnswered = false;
  bool _isQuizCorrect = false;
  bool _isQuizOver = false;
  String? _correctAnswer;
  int _currentQuestionIndex = -1;
  bool _isQuizClosed = false;

  Future<void> _showQuizDialog() async {
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    final int keyAmount = 5;

    _currentQuestionIndex = _random.nextInt(_questions.length);
    _currentQuestion = _questions[_currentQuestionIndex];
    _correctAnswer = _answers[_currentQuestionIndex];

    _currentAnswer = null;
    _isQuizAnswered = false;
    _isQuizCorrect = false;
    bool _isLoading = false;

    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('퀴즈를 푸세요'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_currentQuestion!),
                    SizedBox(height: 16.0),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('O'),
                          value: 'O',
                          groupValue: _currentAnswer,
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _currentAnswer = value;
                                    _isQuizAnswered = true;
                                  });
                                },
                        ),
                        RadioListTile<String>(
                          title: Text('X'),
                          value: 'X',
                          groupValue: _currentAnswer,
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _currentAnswer = value;
                                    _isQuizAnswered = true;
                                  });
                                },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (_isLoading) LinearProgressIndicator(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: !_isQuizAnswered || _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                              _isQuizAnswered = false;
                            });

                            _isQuizCorrect = _currentAnswer == _correctAnswer;

                            if (_isQuizCorrect) {
                              keyModel.addKey(keyAmount);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('정답입니다! 보상: $keyAmount 열쇠')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('오답입니다.')),
                              );
                            }

                            final currentKeyAmount = keyModel.key;

                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      _isQuizCorrect ? '정답입니다!' : '오답입니다.'),
                                  content: Text(
                                    _isQuizCorrect
                                        ? '보상: $keyAmount 열쇠\n현재 보유 열쇠량: $currentKeyAmount'
                                        : '현재 보유 열쇠량: $currentKeyAmount',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );

                            setState(() {
                              _isQuizOver = true;
                            });

                            await Future.delayed(Duration(seconds: 5));

                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }

                            await _showNextQuiz();
                          },
                    child: Text('제출'),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<void> _waitForSollamaResponse() async {
    try {
      final keyModel = Provider.of<KeyModel>(context, listen: false);

      String generatedScenario = await _getCompleteScenario(_prompt);

      if (generatedScenario.isNotEmpty) {
        setState(() {
          _generatedScenario += '\n$generatedScenario';
          keyModel.setCurrentScenario(generatedScenario);
          if (!_isQuizClosed) {
            _isQuizClosed = true;
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('응답을 받는 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _showNextQuiz() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 문제를 푸셨습니다.')),
      );
      return;
    }

    _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;

    _currentQuestion = _questions[_currentQuestionIndex];
    _correctAnswer = _answers[_currentQuestionIndex];

    await _showQuizDialog();
  }

  Future<String> _getCompleteScenario(String prompt) async {
    String response = '';
    while (!_isValidResponse(response)) {
      try {
        response = await _solamaService.generateScenario(prompt);
      } catch (e) {
        print('Error: $e');
        response = 'Error occurred while generating scenario.';
      }
    }
    return response;
  }

  bool _isValidResponse(String response) {
    final lines = response.split('\n');
    return lines.length >= 3;
  }

  void _createNewScenario() async {
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    String currentScenario = keyModel.currentScenario;

    if (currentScenario.isNotEmpty) {
      keyModel.clearCurrentScenario();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('기존 시나리오를 삭제하고 새로 생성합니다.')),
      );
    }

    if (_selectedPersons.isEmpty ||
        _selectedObjects.isEmpty ||
        _selectedPlace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 카드를 선택해 주세요.')),
      );
      return;
    }

    List<String> sentences = [];
    for (var person in _selectedPersons) {
      String role = roles[_random.nextInt(roles.length)];
      String personality = personalities[_random.nextInt(personalities.length)];
      sentences.add("$role 역할로 $person이 나오고, $personality 사람이야.");
    }

    for (var object in _selectedObjects) {
      String purpose = objectPurposes[_random.nextInt(objectPurposes.length)];
      sentences.add("$object이 $purpose");
    }

    sentences.add("$_selectedPlace를 배경으로 해줘");

    int numSituations = _random.nextInt(4) + 1;
    for (var i = 0; i < numSituations; i++) {
      String situation = situations[_random.nextInt(situations.length)];
      sentences.add("$situation");
    }

    String ending = endings[_random.nextInt(endings.length)];
    sentences.add("끝에는 $ending 결말로 마무리해줘");

    _prompt = "이야기를 만들어줘.\n";
    _prompt += sentences.join('\n');
    _prompt += "\n이야기를 만들어줘.\n소설 형식으로 변환해서 작성해줘";
    setState(() {
      _generatedScenario = '';
      _isQuizClosed = false;
    });

    final ownedCardsModel =
        Provider.of<OwnedCardsModel>(context, listen: false);
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
      _generatedScenario = '이야기를 시작합니다..';
    });

    await _showQuizDialog();

    await _waitForSollamaResponse();

    if (_isQuizOver) {
      try {
        String generatedScenario = await _getCompleteScenario(_prompt);
        setState(() {
          _generatedScenario += '\n$generatedScenario';
          keyModel.setCurrentScenario(generatedScenario);
        });
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시나리오 생성 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  void _continueScenario() async {
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    String currentScenario = keyModel.currentScenario;

    if (currentScenario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('진행 중인 시나리오가 없습니다.')),
      );
      return;
    }

    if (_selectedPersons.isEmpty ||
        _selectedObjects.isEmpty ||
        _selectedPlace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 카드를 선택해 주세요.')),
      );
      return;
    }

    List<String> sentences = [];
    for (var person in _selectedPersons) {
      String role = roles[_random.nextInt(roles.length)];
      String personality = personalities[_random.nextInt(personalities.length)];
      sentences.add("$role 역할로 $person이 나오고, $personality 사람이야.");
    }

    for (var object in _selectedObjects) {
      String purpose = objectPurposes[_random.nextInt(objectPurposes.length)];
      sentences.add("$object이 $purpose");
    }

    sentences.add("$_selectedPlace를 배경으로 해줘");

    int numSituations = _random.nextInt(4) + 1;
    for (var i = 0; i < numSituations; i++) {
      String situation = situations[_random.nextInt(situations.length)];
      sentences.add("$situation");
    }

    String ending = endings[_random.nextInt(endings.length)];
    sentences.add("끝에는 $ending 결말로 마무리해줘");

    _prompt = "이야기를 만들어줘.\n";
    _prompt += keyModel.currentScenario + " 라는 이야기의 뒷부분을 이어서 작성해줘 \n";
    _prompt += sentences.join('\n');
    _prompt += "\n이야기를 만들어줘.\n소설 형식으로 변환해서 작성해줘";
    setState(() {
      _generatedScenario = '';
      _isQuizClosed = false;
    });

    final ownedCardsModel =
        Provider.of<OwnedCardsModel>(context, listen: false);
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
      _generatedScenario = '이야기를 시작합니다..';
    });

    await _showQuizDialog();

    await _waitForSollamaResponse();

    if (_isQuizOver) {
      try {
        String generatedScenario = await _getCompleteScenario(_prompt);
        setState(() {
          _generatedScenario += '\n$generatedScenario';
          keyModel.setCurrentScenario(generatedScenario);
        });
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시나리오 생성 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  void _finishScenario() async {
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    String allScenarios = keyModel.currentScenario;
    keyModel.clearCurrentScenario();

    if (allScenarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('진행 중인 시나리오가 없습니다.')),
      );
      return;
    }

    String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? title = '';
        return AlertDialog(
          title: Text('이야기 제목 입력'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: '제목을 입력하세요'),
            onChanged: (value) {
              title = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(title);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );

    if (title != null && title.isNotEmpty) {
      final storyDataModel =
          Provider.of<StoryDataModel>(context, listen: false);
      storyDataModel.addStory(title, allScenarios);

      keyModel.clearCurrentScenario();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoryOwn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownedCardsModel = Provider.of<OwnedCardsModel>(context);
    final keyModel = Provider.of<KeyModel>(context, listen: false);
    final String displayText = _generatedScenario.isNotEmpty
        ? _generatedScenario
        : keyModel.currentScenario;

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
                  '새 스토리 생성',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 폰트 색상을 흰색으로 변경
                    fontFamily: 'AppleSDGothicNeo',
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '인물 카드',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ), // 폰트 색상을 흰색으로 변경
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: ownedCardsModel.ownedPersonCards.map((card) {
                    return ChoiceChip(
                      label: Text(
                        card,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AppleSDGothicNeo',
                        ), // 폰트 색상을 흰색으로 변경
                      ),
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
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Text(
                  '물건 카드',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ), // 폰트 색상을 흰색으로 변경
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: ownedCardsModel.ownedObjectCards.map((card) {
                    return ChoiceChip(
                      label: Text(
                        card,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AppleSDGothicNeo',
                        ), // 폰트 색상을 흰색으로 변경
                      ),
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
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Text(
                  '장소 카드',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'AppleSDGothicNeo',
                  ), // 폰트 색상을 흰색으로 변경
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: ownedCardsModel.ownedPlaceCards.map((card) {
                    return ChoiceChip(
                      label: Text(
                        card,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AppleSDGothicNeo',
                        ), // 폰트 색상을 흰색으로 변경
                      ),
                      selected: _selectedPlace == card,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedPlace = selected ? card : '';
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _createNewScenario,
                      child: Text('새 스토리'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 63, 63, 80),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _continueScenario,
                      child: Text('이어가기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 63, 63, 80),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _finishScenario,
                      child: Text('완성하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 63, 63, 80),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _fontSize =
                              (_fontSize > 10) ? _fontSize - 2 : _fontSize;
                        });
                      },
                      color: Colors.white, // 아이콘 색상을 흰색으로 변경
                    ),
                    Text(
                      '글자 크기',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: Colors.white,
                        fontFamily: 'AppleSDGothicNeo',
                      ), // 폰트 색상을 흰색으로 변경
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _fontSize =
                              (_fontSize < 40) ? _fontSize + 2 : _fontSize;
                        });
                      },
                      color: Colors.white, // 아이콘 색상을 흰색으로 변경
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: Colors.white,
                        fontFamily: 'AppleSDGothicNeo',
                      ), // 폰트 색상을 흰색으로 변경
                    ),
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

class QuizPage extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final VoidCallback onCorrectAnswer;
  final VoidCallback onIncorrectAnswer;

  QuizPage({
    required this.question,
    required this.correctAnswer,
    required this.onCorrectAnswer,
    required this.onIncorrectAnswer,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnswerSubmitted = false;

  void _submitAnswer() {
    setState(() {
      _isAnswerSubmitted = true;
    });
    if (_controller.text.toUpperCase() == widget.correctAnswer) {
      widget.onCorrectAnswer();
    } else {
      widget.onIncorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question),
            SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '답변을 입력하세요',
              ),
              enabled: !_isAnswerSubmitted,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isAnswerSubmitted ? null : _submitAnswer,
              child: Text('답변 제출'),
            ),
          ],
        ),
      ),
    );
  }
}
