import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'wordbook_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 페이지 목록을 build 메소드 밖으로 빼고, 함수를 전달하기 위해
  // _widgetOptions를 인스턴스 변수로 변경합니다.
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(
        onNavigateToQuiz: () => _onItemTapped(1),
      ), // 퀴즈 탭(인덱스 1)으로 이동하는 함수 전달
      const QuizScreen(),
      const WordbookScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body를 재빌드할 때마다 _widgetOptions가 새로 생성되지 않도록 수정
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 고정
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: '퀴즈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '나의 단어장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
