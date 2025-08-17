import 'package:english_words_quiz_app/models/word.dart';

class QuizQuestion {
  final Word correctWord;
  final String questionText;
  final List<String> options;

  QuizQuestion({
    required this.correctWord,
    required this.questionText,
    required this.options,
  });
}
