// lib/screens/temp/review_screen.dart

import 'package:flutter/material.dart';

import '../services/quiz_state_service.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wrongWords = QuizStateService().wrongWords;

    return Scaffold(
      appBar: AppBar(title: const Text('틀린 단어 복습')),
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
  }
}
