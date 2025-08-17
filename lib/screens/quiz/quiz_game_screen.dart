// lib/screens/quiz/quiz_game_screen.dart

import 'package:english_words_quiz_app/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';

import '../../models/quiz_question.dart';
import '../../models/word.dart';

class QuizGameScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String quizType;
  const QuizGameScreen({
    super.key,
    required this.questions,
    required this.quizType,
  });

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;
  final List<Word> _wrongWordsInSession = [];

  void _checkAnswer(String selectedOption) {
    setState(() {
      _isAnswered = true;
      _selectedOption = selectedOption;

      String correctAnswer;
      if (widget.quizType == 'kor_to_eng') {
        correctAnswer = widget.questions[_currentIndex].correctWord.word;
      } else {
        correctAnswer = widget.questions[_currentIndex].correctWord.meaning;
      }

      if (selectedOption == correctAnswer) {
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

    String correctAnswer;
    if (widget.quizType == 'kor_to_eng') {
      correctAnswer = widget.questions[_currentIndex].correctWord.word;
    } else {
      correctAnswer = widget.questions[_currentIndex].correctWord.meaning;
    }

    if (option == correctAnswer) {
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple[400],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                currentQuestion.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '가장 알맞은 것을 고르세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
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
