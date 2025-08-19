import 'dart:convert';

import 'package:english_words_quiz_app/models/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class QuizStateService with ChangeNotifier {
  late SharedPreferences _prefs;

  List<Word> _wrongWords = [];
  List<Word> get wrongWords => _wrongWords;

  int _dailyQuestionsSolved = 0;
  int get dailyQuestionsSolved => _dailyQuestionsSolved;

  DateTime _lastSolvedDate = DateTime.now();

  // --- '나만의 단어장' 기능 관련 코드 추가 ---
  List<Word> _myWords = [];
  List<Word> get myWords => _myWords;
  // --- 여기까지 ---

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStateFromPrefs();
    await _loadMyWords(); // 나만의 단어 불러오기 호출
    _resetDailyProgressIfNeeded();
  }

  Future<void> _loadStateFromPrefs() async {/* ... 기존 코드 ... */}
  void _resetDailyProgressIfNeeded() {/* ... 기존 코드 ... */}
  Future<void> _saveWrongWords() async {/* ... 기존 코드 ... */}
  Future<void> _saveDailyProgress() async {/* ... 기존 코드 ... */}

  // --- '나만의 단어장' 기능 관련 메소드 추가 ---
  Future<void> _loadMyWords() async {
    final myWordsJson = _prefs.getStringList('myWords') ?? [];
    _myWords = myWordsJson
        .map((jsonStr) => Word.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  Future<void> _saveMyWords() async {
    final myWordsJson =
        _myWords.map((word) => jsonEncode(word.toJson())).toList();
    await _prefs.setStringList('myWords', myWordsJson);
  }

  void addMyWord({required String word, required String meaning}) {
    final newWord = Word(
      id: const Uuid().v4(),
      word: word,
      meaning: meaning,
      level: '나만의 단어',
    );
    _myWords.insert(0, newWord); // 맨 앞에 추가
    _saveMyWords();
    notifyListeners();
  }

  void updateMyWord(Word updatedWord) {
    final index = _myWords.indexWhere((w) => w.id == updatedWord.id);
    if (index != -1) {
      _myWords[index] = updatedWord;
      _saveMyWords();
      notifyListeners();
    }
  }

  void deleteMyWord(String wordId) {
    _myWords.removeWhere((w) => w.id == wordId);
    _saveMyWords();
    notifyListeners();
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
