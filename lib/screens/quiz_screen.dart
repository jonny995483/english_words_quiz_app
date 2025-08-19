// lib/screens/quiz_screen.dart

import 'dart:math';

import 'package:english_words_quiz_app/screens/quiz/hangman_game_screen.dart';
import 'package:english_words_quiz_app/screens/quiz/quiz_game_screen.dart';
import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _selectedLevel;
  double _questionCount = 10.0;
  String? _selectedQuizType;

  final List<String> _levels = ['초등', '중고', '전문', '전체'];
  final List<Map<String, dynamic>> _quizTypes = [
    {'type': 'eng_to_kor', 'title': '영단어 보고 뜻 맞추기', 'icon': Icons.translate},
    {'type': 'kor_to_eng', 'title': '뜻 보고 영단어 맞추기', 'icon': Icons.spellcheck},
    {'type': 'hangman', 'title': '행맨 게임', 'icon': Icons.gamepad_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.deepPurple.shade200.withOpacity(0.5),
              expandedHeight: 120.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('퀴즈 풀기', style: TextStyle(color: Colors.black87)),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('1. 난이도를 선택하세요'),
                    const SizedBox(height: 10),
                    _buildLevelSelector(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('2. 문제 수를 선택하세요'),
                    const SizedBox(height: 10),
                    _buildCountSelector(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('3. 퀴즈 종류를 선택하세요'),
                    const SizedBox(height: 10),
                    _buildQuizTypeSelector(),
                    const SizedBox(height: 40),
                    _buildStartButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildLevelSelector() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _levels.map((level) {
        final isSelected = _selectedLevel == level;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedLevel = level;
            });
          },
          borderRadius: BorderRadius.circular(15.0),
          child: Card(
            elevation: isSelected ? 8.0 : 2.0,
            color: isSelected ? Colors.deepPurple[400] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: isSelected
                  ? BorderSide(color: Colors.deepPurple.shade700, width: 2)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 20),
                  if (isSelected) const SizedBox(width: 8),
                  Text(level,
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCountSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Text(
              '${_questionCount.toInt()} 문제',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            Slider(
              value: _questionCount,
              min: 5,
              max: 20,
              divisions: 3,
              label: _questionCount.round().toString(),
              activeColor: Colors.deepPurple.shade400,
              inactiveColor: Colors.deepPurple.shade100,
              onChanged: (double value) {
                setState(() {
                  _questionCount = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTypeSelector() {
    return Column(
      children: _quizTypes.map((type) {
        bool isSelected = _selectedQuizType == type['type'];
        return Card(
          elevation: isSelected ? 8.0 : 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color:
                  isSelected ? Colors.deepPurple.shade400 : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(type['icon'],
                color: isSelected ? Colors.deepPurple.shade700 : Colors.grey,
                size: 30),
            title: Text(type['title'],
                style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87)),
            onTap: () {
              setState(() {
                _selectedQuizType = type['type'];
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartButton() {
    bool isReady = _selectedLevel != null && _selectedQuizType != null;
    return ElevatedButton(
      onPressed: isReady ? _startQuiz : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: const Text('퀴즈 시작!'),
    );
  }

  void _startQuiz() {
    // 1. 선택된 난이도에 맞는 단어 리스트 가져오기
    List<Word> sourceWords;
    switch (_selectedLevel) {
      case '초등':
        sourceWords = WordService.lowWords;
        break;
      case '중고':
        sourceWords = WordService.middleWords;
        break;
      case '전문':
        sourceWords = WordService.highWords;
        break;
      default:
        sourceWords = WordService.totalWords;
    }

    // 2. 버그 수정: 더욱 상세해진 단어 수 검사 로직
    // 4지선다형은 최소 4개, 행맨은 최소 1개의 단어가 필요합니다.
    bool canStartQuiz = true;
    if (_selectedQuizType == 'hangman') {
      // 행맨용 단어 필터링 (너무 길거나 공백 있는 단어 제외)
      sourceWords = sourceWords
          .where((w) => w.word.length <= 10 && !w.word.contains(' '))
          .toList();
      if (sourceWords.isEmpty) {
        canStartQuiz = false;
      }
    } else {
      // 4지선다형 퀴즈
      if (sourceWords.length < 4) {
        canStartQuiz = false;
      }
    }

    // 3. 퀴즈를 시작할 수 없다면 사용자에게 알림을 보여주고 함수 종료
    if (!canStartQuiz) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('선택하신 난이도의 단어 수가 부족하여 퀴즈를 만들 수 없습니다.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // 여기서 함수가 종료되어 더 이상 진행되지 않음
    }

    // 4. 퀴즈 문제 생성 및 화면 이동
    final random = Random();
    final int questionCount = _questionCount.toInt();
    final List<Word> quizWords = List.from(sourceWords)..shuffle();
    final selectedWords = quizWords.take(questionCount).toList();

    if (_selectedQuizType == 'hangman') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HangmanGameScreen(words: selectedWords),
        ),
      );
    } else {
      final List<QuizQuestion> questions = [];
      for (int i = 0; i < selectedWords.length; i++) {
        final correctWord = selectedWords[i];
        String questionText;
        List<String> options;

        if (_selectedQuizType == 'kor_to_eng') {
          questionText = correctWord.meaning;
          final tempOptions = <String>{correctWord.word};
          while (tempOptions.length < 4) {
            final randomWord = sourceWords[random.nextInt(sourceWords.length)];
            if (randomWord.id != correctWord.id)
              tempOptions.add(randomWord.word);
          }
          options = tempOptions.toList()..shuffle();
        } else {
          questionText = correctWord.word;
          final tempOptions = <String>{correctWord.meaning};
          while (tempOptions.length < 4) {
            final randomWord = sourceWords[random.nextInt(sourceWords.length)];
            if (randomWord.id != correctWord.id)
              tempOptions.add(randomWord.meaning);
          }
          options = tempOptions.toList()..shuffle();
        }
        questions.add(QuizQuestion(
          correctWord: correctWord,
          questionText: questionText,
          options: options,
        ));
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizGameScreen(
            questions: questions,
            quizType: _selectedQuizType!,
          ),
        ),
      );
    }
  }
}
