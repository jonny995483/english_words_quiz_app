import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '영어 단어장',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xffd09aff),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        shadowColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              child: Text("안녕"),
            ),
          ),
        ],
      ),
    );
  }
}
