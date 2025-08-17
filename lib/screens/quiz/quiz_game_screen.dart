// lib/screens/quiz/quiz_game_screen.dart

import 'package:english_words_quiz_app/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';

import '../../models/quiz_question.dart';
import '../../models/word.dart';

class QuizGameScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  const QuizGameScreen({super.key, required this.questions});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;
  final List<Word> _wrongWordsInSession = [];

  void _checkAnswer(String selectedMeaning) {
    setState(() {
      _isAnswered = true;
      _selectedOption = selectedMeaning;
      if (selectedMeaning ==
          widget.questions[_currentIndex].correctWord.meaning) {
        _score++;
      } else {
        _wrongWordsInSession.add(widget.questions[_currentIndex].correctWord);
      }
    });
  }

  void _goToNextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedOption = null;
      });
    } else {
      // 퀴즈 종료, 결과 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _score,
            totalQuestions: widget.questions.length,
            wrongWords: _wrongWordsInSession,
          ),
        ),
      );
    }
  }

  Color _getOptionColor(String option) {
    if (!_isAnswered) return Colors.grey.shade200;
    if (option == widget.questions[_currentIndex].correctWord.meaning) {
      return Colors.green.shade200;
    } else if (option == _selectedOption) {
      return Colors.red.shade200;
    }
    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 진행중 (${_currentIndex + 1}/${widget.questions.length})'),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨기기
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 문제 단어
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple[400],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                currentQuestion.correctWord.word,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '가장 알맞은 뜻을 고르세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            // 보기 목록
            ...currentQuestion.options.map((option) {
              return Card(
                color: _getOptionColor(option),
                child: ListTile(
                  title: Text(option, style: const TextStyle(fontSize: 18)),
                  onTap: _isAnswered ? null : () => _checkAnswer(option),
                ),
              );
            }).toList(),
            const Spacer(),
            // 다음 문제 버튼
            if (_isAnswered)
              ElevatedButton(
                onPressed: _goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentIndex < widget.questions.length - 1
                      ? '다음 문제'
                      : '결과 보기',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
