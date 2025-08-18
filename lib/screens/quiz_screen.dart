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
      appBar: AppBar(
        title: Center(child: const Text('퀴즈 풀기')),
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
          max: 20, // 행맨은 문제 수를 조금 줄이는 게 좋습니다.
          divisions: 3,
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
            title: Text(type['title'],
                style: const TextStyle(fontWeight: FontWeight.w600)),
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

    // 행맨 게임은 너무 긴 단어는 제외하는 것이 좋습니다. (예: 10자 이하)
    sourceWords = sourceWords
        .where((w) => w.word.length <= 10 && !w.word.contains(' '))
        .toList();

    if (sourceWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('퀴즈를 만들 단어가 부족합니다.')),
      );
      return;
    }

    final random = Random();
    final int questionCount = _questionCount.toInt();
    final List<Word> quizWords = List.from(sourceWords)..shuffle();
    final selectedWords = quizWords.take(questionCount).toList();

    if (_selectedQuizType == 'hangman') {
      // 행맨 게임 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HangmanGameScreen(words: selectedWords),
        ),
      );
    } else {
      // 기존 4지선다 퀴즈 로직
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
