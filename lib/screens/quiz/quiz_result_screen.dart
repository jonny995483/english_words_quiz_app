// lib/screens/quiz/quiz_result_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // initState에서는 context.read를 직접 호출할 수 없으므로,
    // 첫 프레임이 빌드된 후에 호출되도록 합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordResult();
    });
  }

  void _recordResult() {
    final quizState = context.read<QuizStateService>();
    quizState.recordQuizSolved(widget.totalQuestions);
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
