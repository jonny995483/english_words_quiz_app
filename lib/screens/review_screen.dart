// lib/screens/temp/review_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/quiz_state_service.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  // 삭제 확인 대화상자를 표시하는 메소드
  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('모두 삭제'),
          content: const Text('틀린 단어 목록을 모두 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Provider를 통해 서비스의 메소드 호출
                context.read<QuizStateService>().clearWrongWords();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizStateService>(
      builder: (context, quizState, child) {
        final wrongWords = quizState.wrongWords;

        return Scaffold(
          appBar: AppBar(
            title: const Text('틀린 단어 복습'),
            actions: [
              // '모두 정리' 버튼
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: '모두 정리',
                // 목록이 비어있으면 버튼 비활성화
                onPressed: wrongWords.isEmpty
                    ? null
                    : () => _showClearConfirmDialog(context),
              ),
            ],
          ),
          body: wrongWords.isEmpty
              ? const Center(
                  child: Text(
                    '틀린 단어가 없습니다!\n퀴즈를 풀고 다시 확인해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: wrongWords.length,
                  itemBuilder: (context, index) {
                    final word = wrongWords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          word.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          word.meaning,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.bookmark,
                          color: Colors.amber.shade600,
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
