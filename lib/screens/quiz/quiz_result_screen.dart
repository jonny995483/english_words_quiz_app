// lib/screens/quiz/quiz_result_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../services/quiz_state_service.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<Word> wrongWords;
  final List<Word> sessionWords; // 새로 추가: 전체 단어 목록을 받을 변수

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.wrongWords,
    this.sessionWords = const [], // 기본값을 빈 리스트로 설정하여 기존 퀴즈와 호환성 유지
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordResult();
    });
  }

  void _recordResult() {
    // 4지선다 퀴즈의 경우에만 학습 진행도와 틀린 단어를 기록
    if (widget.sessionWords.isEmpty) {
      final quizState = context.read<QuizStateService>();
      quizState.recordQuizSolved(widget.totalQuestions);
      for (final word in widget.wrongWords) {
        quizState.addWrongWord(word);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 수정: 어떤 목록을 보여줄지 결정
    final bool showAllWords = widget.sessionWords.isNotEmpty;
    final List<Word> wordsToShow =
        showAllWords ? widget.sessionWords : widget.wrongWords;
    final String titleText = showAllWords ? '이번 퀴즈 단어 목록' : '틀린 단어';

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
            if (wordsToShow.isNotEmpty)
              Text(
                titleText,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Expanded(
              child: wordsToShow.isEmpty
                  ? const Center(child: Text('표시할 단어가 없습니다.'))
                  : ListView.builder(
                      itemCount: wordsToShow.length,
                      itemBuilder: (context, index) {
                        final word = wordsToShow[index];
                        return ListTile(
                          title: Text(word.word,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
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
                    minimumSize: const Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
