import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학습 통계')),
      body: const Center(
        child: Text('일별/주별/월별 학습 통계가 여기에 표시됩니다.'),
      ),
    );
  }
}
