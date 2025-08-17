import 'package:flutter/material.dart';

import 'main_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  // 버튼 클릭 시 MainScreen으로 이동하는 함수
  void _navigateToMainScreen(BuildContext context) {
    // pushReplacement를 사용하여 이 화면으로 다시 돌아오지 않도록 합니다.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[600],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  '나만의 영어 단어장',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => _navigateToMainScreen(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _navigateToMainScreen(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('회원가입'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _navigateToMainScreen(context),
                  child: Text(
                    '게스트로 계속하기',
                    style: TextStyle(
                      color: Colors.deepPurple[100],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
