import 'package:english_words_quiz_app/screens/review_screen.dart';
import 'package:english_words_quiz_app/screens/stats_screen.dart';
import 'package:english_words_quiz_app/services/word_service.dart';
import 'package:flutter/material.dart';

import '../services/quiz_state_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToQuiz; // 퀴즈 탭으로 이동하는 콜백 함수

  const HomeScreen({super.key, required this.onNavigateToQuiz});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // QuizStateService 인스턴스 가져오기
    final quizState = QuizStateService();

    return Scaffold(
      body: Container(
        // ... (배경 디자인 동일)
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
                // quizState 데이터를 전달
                _buildProgressCard(context, quizState.dailyQuestionsSolved),
                const SizedBox(height: 30),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. 환영 메시지 위젯
  Widget _buildWelcomeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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

  // 2. 오늘의 단어 카드 위젯
  Widget _buildTodayWordCard(BuildContext context) {
    // WordService에서 오늘의 단어 정보를 가져옵니다.
    final word = WordService.wordOfTheDay;

    // 만약 단어를 불러오지 못했다면(null이라면) 대체 위젯을 보여줍니다.
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

    // 단어 정보가 있다면 정상적으로 카드를 구성합니다.
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
              // word.word를 대문자로 시작하게 만듭니다.
              word.word.substring(0, 1).toUpperCase() + word.word.substring(1),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            // 발음 기호는 데이터에 없으므로 일단 주석 처리하거나 삭제합니다.
            // const Text(
            //   '[ɪˈfemərəl]',
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
            const SizedBox(height: 10),
            Text(
              word.meaning, // 단어의 뜻을 표시합니다.
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const Divider(height: 30),
            // 예문도 데이터에 없으므로 일단 삭제하거나 간단한 메시지를 넣습니다.
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
                onPressed: () {
                  // TODO: 내 단어장에 추가하는 기능 구현
                },
                child: const Text('내 단어장에 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 학습 진행도 카드 위젯
  Widget _buildProgressCard(BuildContext context, int solvedCount) {
    const int goal = 20;
    final double progress = solvedCount > goal ? 1.0 : solvedCount / goal;

    return Card(
      // ... 카드 디자인 동일
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
                    value: progress, // 실제 진행도 반영
                    strokeWidth: 8,
                    backgroundColor: Colors.deepPurple.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple.shade400,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}%', // 실제 % 반영
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
                    '오늘 목표 $goal개 중 $solvedCount개를 학습했어요!', // 실제 데이터 반영
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

  // 4. 빠른 메뉴 위젯
  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      // ... GridView 속성 동일
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
          onTap: onNavigateToQuiz, // 전달받은 콜백 함수 실행
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
          onTap: () {}, // 미구현
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

  // 빠른 메뉴에 사용될 개별 카드 위젯
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
