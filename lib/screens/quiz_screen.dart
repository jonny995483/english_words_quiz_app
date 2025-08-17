// lib/screens/quiz_screen.dart

import 'dart:math';

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
      appBar: AppBar(
        title: const Text('퀴즈 설정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('1. 난이도를 선택하세요'),
            _buildLevelSelector(),
            const SizedBox(height: 30),
            _buildSectionTitle('2. 문제 수를 선택하세요'),
            _buildCountSelector(),
            const SizedBox(height: 30),
            _buildSectionTitle('3. 퀴즈 종류를 선택하세요'),
            _buildQuizTypeSelector(),
            const SizedBox(height: 40),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLevelSelector() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _levels.map((level) {
        return ChoiceChip(
          label: Text(level, style: const TextStyle(fontSize: 16)),
          selected: _selectedLevel == level,
          onSelected: (selected) {
            setState(() {
              _selectedLevel = selected ? level : null;
            });
          },
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          selectedColor: Colors.deepPurple[300],
          labelStyle: TextStyle(
            color: _selectedLevel == level ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCountSelector() {
    return Column(
      children: [
        Text(
          '${_questionCount.toInt()} 문제',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[700],
          ),
        ),
        Slider(
          value: _questionCount,
          min: 5,
          max: 50,
          divisions: 9,
          label: _questionCount.round().toString(),
          onChanged: (double value) {
            setState(() {
              _questionCount = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuizTypeSelector() {
    return Column(
      children: _quizTypes.map((type) {
        bool isSelected = _selectedQuizType == type['type'];
        return Card(
          elevation: isSelected ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.deepPurple : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: Icon(type['icon'], color: Colors.deepPurple),
            title: Text(
              type['title'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
      default: // '전체' 또는 예외 상황
        sourceWords = WordService.totalWords;
    }

    if (sourceWords.length < 4) {
      // 퀴즈 생성을 위한 최소 단어 수가 부족할 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('퀴즈를 만들기에 단어 수가 부족합니다.')),
      );
      return;
    }

    // 2. 문제 생성
    final random = Random();
    final List<QuizQuestion> questions = [];

    // 문제로 사용할 단어들을 랜덤으로 섞고 필요한 개수만큼 선택
    final List<Word> quizWords = List.from(sourceWords)..shuffle();
    final int questionCount = _questionCount.toInt();

    for (int i = 0; i < questionCount && i < quizWords.length; i++) {
      final correctWord = quizWords[i];
      final options = <String>{correctWord.meaning}; // 정답 보기를 set에 추가 (중복 방지)

      // 오답 보기 생성
      while (options.length < 4) {
        final randomWord = sourceWords[random.nextInt(sourceWords.length)];
        if (randomWord.id != correctWord.id) {
          options.add(randomWord.meaning);
        }
      }

      // 보기 순서 섞기
      final shuffledOptions = options.toList()..shuffle();

      questions.add(
        QuizQuestion(
          correctWord: correctWord,
          options: shuffledOptions,
        ),
      );
    }

    // 3. 퀴즈 게임 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizGameScreen(questions: questions),
      ),
    );
  }
}
