import 'package:flutter/material.dart';

class WordbookScreen extends StatelessWidget {
  const WordbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 단어장'),
      ),
      body: const Center(
        child: Text(
          '나만의 단어장 페이지',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
