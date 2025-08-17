import 'dart:convert';

import 'package:english_words_quiz_app/models/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStateService with ChangeNotifier {
  late SharedPreferences _prefs;

  List<Word> _wrongWords = [];
  List<Word> get wrongWords => _wrongWords;

  int _dailyQuestionsSolved = 0;
  int get dailyQuestionsSolved => _dailyQuestionsSolved;

  DateTime _lastSolvedDate = DateTime.now();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStateFromPrefs();
    _resetDailyProgressIfNeeded();
  }

  Future<void> _loadStateFromPrefs() async {
    final wrongWordsJson = _prefs.getStringList('wrongWords') ?? [];
    _wrongWords = wrongWordsJson
        .map((jsonStr) => Word.fromJson(jsonDecode(jsonStr)))
        .toList();

    _dailyQuestionsSolved = _prefs.getInt('dailyQuestionsSolved') ?? 0;
    final lastDateStr = _prefs.getString('lastSolvedDate');
    if (lastDateStr != null) {
      _lastSolvedDate = DateTime.parse(lastDateStr);
    }
  }

  void _resetDailyProgressIfNeeded() {
    final now = DateTime.now();
    if (now.year != _lastSolvedDate.year ||
        now.month != _lastSolvedDate.month ||
        now.day != _lastSolvedDate.day) {
      _dailyQuestionsSolved = 0;
      _lastSolvedDate = now;
      _saveDailyProgress();
      print("일일 진행도가 리셋되었습니다.");
    }
  }

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

  void addWrongWord(Word word) {
    if (!_wrongWords.any((w) => w.id == word.id)) {
      _wrongWords.insert(0, word);
      _saveWrongWords();
      notifyListeners();
    }
  }

  // --- 여기부터가 새로 추가/수정된 부분입니다 ---

  // 틀린 단어 목록 전체를 삭제하는 메소드
  void clearWrongWords() {
    _wrongWords.clear();
    _saveWrongWords();
    notifyListeners();
  }

  // --- 여기까지 ---

  void recordQuizSolved(int count) {
    _dailyQuestionsSolved += count;
    _lastSolvedDate = DateTime.now();
    _saveDailyProgress();
    notifyListeners();
  }

  Map<String, int> getStatistics() {
    return {
      'total_solved': 123,
      'correct': 100,
      'incorrect': 23,
    };
  }
}
