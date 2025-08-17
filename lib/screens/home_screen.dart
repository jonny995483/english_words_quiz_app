import 'package:english_words_quiz_app/screens/review_screen.dart';
import 'package:english_words_quiz_app/screens/stats_screen.dart';
import 'package:english_words_quiz_app/services/word_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/quiz_state_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToQuiz;

  const HomeScreen({super.key, required this.onNavigateToQuiz});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 30),
                _buildTodayWordCard(context),
                const SizedBox(height: 30),
                Consumer<QuizStateService>(
                  builder: (context, quizState, child) {
                    return _buildProgressCard(
                      context,
                      quizState.dailyQuestionsSolved,
                    );
                  },
                ),
                const SizedBox(height: 30),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '오늘도 단어 학습을 시작해볼까요?',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 32,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayWordCard(BuildContext context) {
    final word = WordService.wordOfTheDay;

    if (word == null) {
      return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text('오늘의 단어를 불러오는 데 실패했습니다.'),
          ),
        ),
      );
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.deepPurple.shade300),
                const SizedBox(width: 8),
                Text(
                  '오늘의 단어',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              word.word.substring(0, 1).toUpperCase() + word.word.substring(1),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              word.meaning,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const Divider(height: 30),
            Text(
              '등급: ${word.level}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('내 단어장에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, int solvedCount) {
    const int goal = 20;
    final double progress = solvedCount > goal ? 1.0 : solvedCount / goal;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.deepPurple.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple.shade400,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '학습 진행도',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '오늘 목표 $goal개 중 $solvedCount개를 학습했어요!',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionCard(
          context,
          icon: Icons.quiz,
          title: '퀴즈 풀기',
          color: Colors.deepPurple.shade300,
          onTap: onNavigateToQuiz,
        ),
        _buildActionCard(
          context,
          icon: Icons.menu_book,
          title: '단어 복습',
          color: Colors.purple.shade300,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ReviewScreen(),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.add_circle,
          title: '단어 추가',
          color: Colors.indigo.shade300,
          onTap: () {},
        ),
        _buildActionCard(
          context,
          icon: Icons.bar_chart,
          title: '학습 통계',
          color: Colors.blue.shade300,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const StatsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
