import 'package:english_words_quiz_app/models/word.dart';

class QuizQuestion {
  final Word correctWord; // 정답이 되는 Word 객체
  final List<String> options; // 4개의 보기 (뜻)

  QuizQuestion({
    required this.correctWord,
    required this.options,
  });
}
