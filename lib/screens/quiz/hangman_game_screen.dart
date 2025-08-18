import 'package:english_words_quiz_app/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';

import '../../models/word.dart';

class HangmanGameScreen extends StatefulWidget {
  final List<Word> words;
  const HangmanGameScreen({super.key, required this.words});

  @override
  State<HangmanGameScreen> createState() => _HangmanGameScreenState();
}

class _HangmanGameScreenState extends State<HangmanGameScreen> {
  int _currentIndex = 0;
  late Word _currentWord;
  Set<String> _guessedLetters = {};
  int _wrongGuesses = 0;
  bool _isRoundOver = false;
  int _winAnimationStep = 0;

  // 새로 추가: 승리 횟수를 기록하는 변수
  int _wins = 0;

  final List<String> _alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

  @override
  void initState() {
    super.initState();
    _setupNewRound();
  }

  void _setupNewRound() {
    setState(() {
      _currentWord = widget.words[_currentIndex];
      _guessedLetters.clear();
      _wrongGuesses = 0;
      _isRoundOver = false;
      _winAnimationStep = 0;
    });
  }

  void _handleGuess(String letter) {
    if (_isRoundOver || _guessedLetters.contains(letter)) return;

    setState(() {
      _guessedLetters.add(letter);
      if (!_currentWord.word.toLowerCase().contains(letter)) {
        _wrongGuesses++;
      }
      _checkRoundStatus();
    });
  }

  void _checkRoundStatus() {
    bool wordGuessed = _currentWord.word
        .toLowerCase()
        .split('')
        .every((letter) => _guessedLetters.contains(letter));

    if (wordGuessed) {
      setState(() {
        _isRoundOver = true;
        _wins++; // 수정: 정답을 맞혔을 때 승리 횟수 증가
      });
      _startWinAnimation();
    } else if (_wrongGuesses >= 6) {
      setState(() {
        _isRoundOver = true;
      });

      final lostRoundIndex = _currentIndex;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && _currentIndex == lostRoundIndex) {
          setState(() {
            _wrongGuesses = 7;
          });
        }
      });
    }
  }

  void _startWinAnimation() async {
    final winRoundIndex = _currentIndex;

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || _currentIndex != winRoundIndex) return;
    setState(() {
      _winAnimationStep = 1;
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted || _currentIndex != winRoundIndex) return;
    setState(() {
      _winAnimationStep = 2;
    });
  }

  void _goToNext() {
    if (_currentIndex < widget.words.length - 1) {
      setState(() {
        _currentIndex++;
        _setupNewRound();
      });
    } else {
      // 수정: 결과 화면으로 정확한 점수(_wins)와 전체 단어 목록(widget.words) 전달
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _wins,
            totalQuestions: widget.words.length,
            wrongWords: const [], // 행맨은 '틀린 단어 복습'에 추가하지 않음
            sessionWords: widget.words, // 새로 추가: 전체 단어 목록 전달
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('행맨 게임 (${_currentIndex + 1}/${widget.words.length})'),
        automaticallyImplyLeading: false,
      ),
      // 버그 수정: Column을 Expanded와 Flexible로 재구성하여 화면 공간을 동적으로 분배
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment와 crossAxisAlignment로 자식 위젯들의 정렬을 제어
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 이미지 영역: 남는 공간을 최대한 차지하도록 Expanded 사용
            Expanded(
              flex: 5, // 이미지에 더 많은 공간(5)을 할당
              child: _buildHangmanImage(),
            ),
            // 2. 단어 표시 영역: 고정된 높이를 가짐
            _buildWordDisplay(),
            // 3. 키보드 또는 결과 영역: 남는 공간을 유연하게 차지하도록 Flexible 사용
            Flexible(
              flex: 4, // 키보드/결과 영역에 적절한 공간(4)을 할당
              child: Center(
                // 자식 위젯을 중앙에 배치
                child: _isRoundOver ? _buildRoundResult() : _buildKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHangmanImage() {
    final bool isWin = _wrongGuesses < 6;
    String imagePath;

    if (_isRoundOver && isWin) {
      if (_winAnimationStep == 1) {
        imagePath = 'assets/hangman_images/hangman_win_1.png';
      } else if (_winAnimationStep == 2) {
        imagePath = 'assets/hangman_images/hangman_win_2.png';
      } else {
        imagePath = 'assets/hangman_images/hangman_${_wrongGuesses + 1}.png';
      }
    } else {
      final imageNumber = _wrongGuesses + 1;
      imagePath = 'assets/hangman_images/hangman_$imageNumber.png';
    }

    // 버그 수정: Expanded가 크기를 제어하므로, 고정 높이 제약은 제거.
    // BoxFit.contain이 이미지 비율을 유지해 줍니다.
    return Image.asset(imagePath, fit: BoxFit.contain);
  }

  Widget _buildWordDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: _currentWord.word.split('').map((letter) {
          final isLetterGuessed =
              _guessedLetters.contains(letter.toLowerCase());
          final shouldReveal =
              isLetterGuessed || (_isRoundOver && _wrongGuesses >= 6);

          return Container(
            width: 30,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.deepPurple.shade200,
                  width: 3,
                ),
              ),
            ),
            child: Center(
              child: Text(
                shouldReveal ? letter.toUpperCase() : '',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyboard() {
    return SingleChildScrollView(
      // 키보드가 작은 화면에서 잘리지 않도록 스크롤 추가
      child: Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        alignment: WrapAlignment.center,
        children: _alphabet.map((letter) {
          final bool guessed = _guessedLetters.contains(letter);
          return ElevatedButton(
            onPressed: guessed ? null : () => _handleGuess(letter),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(40, 40),
              padding: EdgeInsets.zero,
              backgroundColor: guessed ? Colors.grey : Colors.deepPurple[100],
              foregroundColor: Colors.black87,
            ),
            child: Text(letter.toUpperCase(),
                style: const TextStyle(fontSize: 18)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoundResult() {
    final bool isWin = _wrongGuesses < 6;

    if (isWin && _winAnimationStep < 2) {
      return const SizedBox.shrink(); // 애니메이션 동안 아무것도 표시하지 않음
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_wrongGuesses == 7)
          Text(
            'GAME OVER',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700),
          )
        else if (isWin)
          Text(
            'SUCCESS!',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700),
          ),
        const SizedBox(height: 8),
        Text(
          '정답: ${_currentWord.word} (${_currentWord.meaning})',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _goToNext,
          child:
              Text(_currentIndex < widget.words.length - 1 ? '다음 문제' : '결과 보기'),
        ),
      ],
    );
  }
}
