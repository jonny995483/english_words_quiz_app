// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _selectedLevel;
  double _questionCount = 10.0;
  String? _selectedQuizType;

  final List<String> _levels = ['초등', '중고', '전문', '전체'];
  final List<Map<String, dynamic>> _quizTypes = [
    {'type': 'eng_to_kor', 'title': '영단어 보고 뜻 맞추기', 'icon': Icons.translate},
    {'type': 'kor_to_eng', 'title': '뜻 보고 영단어 맞추기', 'icon': Icons.spellcheck},
    {'type': 'hangman', 'title': '행맨 게임', 'icon': Icons.gamepad_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 설정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('1. 난이도를 선택하세요'),
            _buildLevelSelector(),
            const SizedBox(height: 30),
            _buildSectionTitle('2. 문제 수를 선택하세요'),
            _buildCountSelector(),
            const SizedBox(height: 30),
            _buildSectionTitle('3. 퀴즈 종류를 선택하세요'),
            _buildQuizTypeSelector(),
            const SizedBox(height: 40),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLevelSelector() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _levels.map((level) {
        return ChoiceChip(
          label: Text(level, style: const TextStyle(fontSize: 16)),
          selected: _selectedLevel == level,
          onSelected: (selected) {
            setState(() {
              _selectedLevel = selected ? level : null;
            });
          },
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          selectedColor: Colors.deepPurple[300],
          labelStyle: TextStyle(
            color: _selectedLevel == level ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCountSelector() {
    return Column(
      children: [
        Text(
          '${_questionCount.toInt()} 문제',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[700],
          ),
        ),
        Slider(
          value: _questionCount,
          min: 5,
          max: 50,
          divisions: 9,
          label: _questionCount.round().toString(),
          onChanged: (double value) {
            setState(() {
              _questionCount = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuizTypeSelector() {
    return Column(
      children: _quizTypes.map((type) {
        bool isSelected = _selectedQuizType == type['type'];
        return Card(
          elevation: isSelected ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.deepPurple : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: Icon(type['icon'], color: Colors.deepPurple),
            title: Text(
              type['title'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              setState(() {
                _selectedQuizType = type['type'];
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartButton() {
    bool isReady = _selectedLevel != null && _selectedQuizType != null;
    return ElevatedButton(
      onPressed: isReady ? _startQuiz : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('퀴즈 시작!'),
    );
  }

  void _startQuiz() {
    // TODO: 실제 퀴즈 화면으로 네비게이션
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '준비: $_selectedLevel 난이도, ${_questionCount.toInt()}문제, $_selectedQuizType 퀴즈',
        ),
      ),
    );
  }
}
