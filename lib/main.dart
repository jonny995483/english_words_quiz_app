import 'package:english_words_quiz_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '나만의 영어 단어장',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 앱의 기본 색상을 보라색 계열로 설정합니다.
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50], // 배경색을 연한 보라색으로
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[600], // 앱바 색상
          foregroundColor: Colors.white, // 앱바 텍스트 및 아이콘 색상
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple[700], // 선택된 아이템 색상
          unselectedItemColor: Colors.grey[500], // 선택되지 않은 아이템 색상
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[400], // 버튼 배경색
            foregroundColor: Colors.white, // 버튼 텍스트색
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
