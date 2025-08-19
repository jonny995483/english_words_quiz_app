import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정 및 계정'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('계정 정보'),
            subtitle: Text('이메일, 비밀번호 변경'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림 설정'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // 로그아웃 확인 대화상자 표시
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('로그아웃',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService().signOut();
                // AuthGate가 상태 변경을 감지하고 자동으로 로그인 화면으로 보냅니다.
              }
            },
          ),
        ],
      ),
    );
  }
}
