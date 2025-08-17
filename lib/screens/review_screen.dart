import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('틀린 단어 복습')),
      body: const Center(
        child: Text('최근에 틀린 단어 목록이 여기에 표시됩니다.'),
      ),
    );
  }
}
