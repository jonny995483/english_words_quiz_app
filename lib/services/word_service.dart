// lib/services/word_service.dart

import 'dart:convert';
import 'dart:math'; // Random 클래스를 사용하기 위해 import

import 'package:english_words_quiz_app/models/word.dart';
import 'package:flutter/services.dart' show rootBundle;

class WordService {
  static List<Word> totalWords = [];
  static List<Word> lowWords = [];
  static List<Word> middleWords = [];
  static List<Word> highWords = [];

  // 오늘의 단어를 저장할 static 변수 추가
  static Word? wordOfTheDay;

  static Future<void> loadWords() async {
    try {
      final List<String> jsonStrings = await Future.wait([
        rootBundle.loadString('assets/english_words/english_words_total.json'),
        rootBundle.loadString('assets/english_words/english_words_low.json'),
        rootBundle.loadString('assets/english_words/english_words_middle.json'),
        rootBundle.loadString('assets/english_words/english_words_high.json'),
      ]);

      totalWords = _parseWords(jsonStrings[0]);
      lowWords = _parseWords(jsonStrings[1]);
      middleWords = _parseWords(jsonStrings[2]);
      highWords = _parseWords(jsonStrings[3]);

      // 단어 로딩이 완료된 후, 오늘의 단어를 선택하는 함수 호출
      _selectWordOfTheDay();

      print('단어 데이터 로딩 완료!');
      print('총 단어 수: ${totalWords.length}');
      // 오늘의 단어가 잘 선택되었는지 로그로 확인
      print('오늘의 단어: ${wordOfTheDay?.word}');
    } catch (e) {
      print('단어 데이터 로딩 중 오류 발생: $e');
    }
  }

  // 오늘의 단어를 랜덤으로 선택하는 내부 함수
  static void _selectWordOfTheDay() {
    // 단어 목록이 비어있지 않은 경우에만 실행
    if (totalWords.isNotEmpty) {
      final random = Random();
      // 0부터 전체 단어 수 - 1 사이의 랜덤 인덱스 생성
      final index = random.nextInt(totalWords.length);
      wordOfTheDay = totalWords[index];
    }
  }

  static List<Word> _parseWords(String jsonString) {
    final List<dynamic> parsedJson = jsonDecode(jsonString);
    return parsedJson.map((json) => Word.fromJson(json)).toList();
  }
}
