// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'services/quiz_state_service.dart';
import 'services/word_service.dart'; // WordService import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final quizStateService = QuizStateService();
  await WordService.loadWords();
  await quizStateService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => quizStateService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
