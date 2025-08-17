import 'dart:convert';

import 'package:english_words_quiz_app/models/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStateService {
  // 싱글톤 인스턴스
  static final QuizStateService _instance = QuizStateService._internal();
  factory QuizStateService() => _instance;
  QuizStateService._internal();

  late SharedPreferences _prefs;

  // 상태 변수들
  List<Word> _wrongWords = [];
  int _dailyQuestionsSolved = 0;
  DateTime _lastSolvedDate = DateTime.now();

  // 외부에서 접근할 getter
  List<Word> get wrongWords => _wrongWords;
  int get dailyQuestionsSolved => _dailyQuestionsSolved;

  // 서비스 초기화 (앱 시작 시 호출)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStateFromPrefs();
    _resetDailyProgressIfNeeded();
  }

  // 데이터 불러오기
  Future<void> _loadStateFromPrefs() async {
    // 틀린 단어 불러오기
    final wrongWordsJson = _prefs.getStringList('wrongWords') ?? [];
    _wrongWords = wrongWordsJson
        .map((jsonStr) => Word.fromJson(jsonDecode(jsonStr)))
        .toList();

    // 일일 진행도 불러오기
    _dailyQuestionsSolved = _prefs.getInt('dailyQuestionsSolved') ?? 0;
    final lastDateStr = _prefs.getString('lastSolvedDate');
    if (lastDateStr != null) {
      _lastSolvedDate = DateTime.parse(lastDateStr);
    }
  }

  // 매일 자정이 지나면 일일 진행도 리셋
  void _resetDailyProgressIfNeeded() {
    final now = DateTime.now();
    if (now.year != _lastSolvedDate.year ||
        now.month != _lastSolvedDate.month ||
        now.day != _lastSolvedDate.day) {
      _dailyQuestionsSolved = 0;
      _lastSolvedDate = now;
      _saveDailyProgress(); // 리셋된 상태 저장
      print("일일 진행도가 리셋되었습니다.");
    }
  }

  // 데이터 저장 (private 메소드)
  Future<void> _saveWrongWords() async {
    final wrongWordsJson = _wrongWords
        .map((word) => jsonEncode(word.toJson()))
        .toList();
    await _prefs.setStringList('wrongWords', wrongWordsJson);
  }

  Future<void> _saveDailyProgress() async {
    await _prefs.setInt('dailyQuestionsSolved', _dailyQuestionsSolved);
    await _prefs.setString('lastSolvedDate', _lastSolvedDate.toIso8601String());
  }

  // --- 외부에서 호출할 메소드들 ---

  // 틀린 단어 추가
  void addWrongWord(Word word) {
    // 중복 추가 방지
    if (!_wrongWords.any((w) => w.id == word.id)) {
      _wrongWords.add(word);
      _saveWrongWords();
    }
  }

  // 퀴즈 문제 풀 때마다 호출
  void recordQuizSolved(int count) {
    _dailyQuestionsSolved += count;
    _lastSolvedDate = DateTime.now();
    _saveDailyProgress();
  }

  // 통계 기능 (지금은 간단한 예시)
  Map<String, int> getStatistics() {
    // TODO: 나중에 더 정교한 통계 로직 구현
    return {
      'total_solved': 123,
      'correct': 100,
      'incorrect': 23,
    };
  }
}
