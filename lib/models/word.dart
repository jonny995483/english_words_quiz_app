// lib/models/word.dart

class Word {
  final String id;
  final String word;
  final String meaning;
  final String level;
  final String? variant1; // 변형 필드는 없을 수도 있으므로 nullable(?)로 선언
  final String? variant2;

  Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.level,
    this.variant1,
    this.variant2,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '단어': word,
      '뜻': meaning,
      '등급': level,
      '변형1': variant1,
      '변형2': variant2,
    };
  }

  // JSON(Map<String, dynamic>) 데이터를 Word 객체로 변환하는 factory 생성자
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['단어'],
      meaning: json['뜻'],
      level: json['등급'],
      variant1: json['변형1'], // 없는 경우 null이 됨
      variant2: json['변형2'],
    );
  }
}
