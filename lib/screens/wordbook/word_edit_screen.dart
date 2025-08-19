import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../services/quiz_state_service.dart';

class WordEditScreen extends StatefulWidget {
  final Word? word;

  const WordEditScreen({super.key, this.word});

  @override
  State<WordEditScreen> createState() => _WordEditScreenState();
}

class _WordEditScreenState extends State<WordEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _wordController;
  late TextEditingController _meaningController;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.word?.word ?? '');
    _meaningController =
        TextEditingController(text: widget.word?.meaning ?? '');
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  void _saveWord() {
    if (_formKey.currentState!.validate()) {
      final quizState = context.read<QuizStateService>();
      if (widget.word == null) {
        quizState.addMyWord(
          word: _wordController.text,
          meaning: _meaningController.text,
        );
      } else {
        final updatedWord = Word(
          id: widget.word!.id,
          word: _wordController.text,
          meaning: _meaningController.text,
          level: widget.word!.level,
        );
        quizState.updateMyWord(updatedWord);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word == null ? '새 단어 추가' : '단어 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: _saveWord,
            tooltip: '저장',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            // SingleChildScrollView 대신 ListView 사용
            padding: const EdgeInsets.all(20.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _wordController,
                    decoration: const InputDecoration(
                      labelText: '단어 (Word)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.abc),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '단어를 입력하세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _meaningController,
                    decoration: const InputDecoration(
                      labelText: '뜻 (Meaning)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.translate),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '뜻을 입력하세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
