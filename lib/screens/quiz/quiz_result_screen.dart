// lib/screens/quiz/quiz_result_screen.dart

import 'package:flutter/material.dart';

import '../../models/word.dart';
import '../../services/quiz_state_service.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<Word> wrongWords;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.wrongWords,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 빌드되자마자 결과 기록
    _recordResult();
  }

  void _recordResult() {
    final quizState = QuizStateService();
    // 1. 총 푼 문제 수 기록
    quizState.recordQuizSolved(widget.totalQuestions);
    // 2. 틀린 단어들 저장
    for (final word in widget.wrongWords) {
      quizState.addWrongWord(word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 결과'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '수고하셨습니다!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.totalQuestions} 문제 중 ${widget.score}개를 맞췄어요!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            if (widget.wrongWords.isNotEmpty)
              const Text(
                '틀린 단어',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.wrongWords.length,
                itemBuilder: (context, index) {
                  final word = widget.wrongWords[index];
                  return ListTile(
                    title: Text(word.word),
                    subtitle: Text(word.meaning),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // 홈 화면으로 돌아가기 (퀴즈 관련 화면 스택 모두 제거)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('홈으로 돌아가기'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
