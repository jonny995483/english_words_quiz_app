// lib/main.dart

import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'services/quiz_state_service.dart';
import 'services/word_service.dart'; // WordService import

// main 함수를 async로 변경
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 앱 서비스들 초기화
  await WordService.loadWords();
  await QuizStateService().init(); // QuizStateService 초기화

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ... 기존 MyApp 코드와 동일 ...
    return MaterialApp(
      title: '나만의 영어 단어장',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[600],
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple[700],
          unselectedItemColor: Colors.grey[500],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[400],
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
