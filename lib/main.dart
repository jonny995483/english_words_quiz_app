// lib/main.dart

import 'package:english_words_quiz_app/widgets/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/quiz_state_service.dart';
import 'services/word_service.dart'; // WordService import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        // 이 테마가 앱 전체에 적용됩니다.
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[600],
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
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
      home: const AuthGate(), // 앱의 첫 화면은 AuthGate
    );
  }
}
