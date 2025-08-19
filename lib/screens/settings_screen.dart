import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인된 사용자 정보를 가져옵니다.
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.deepPurple.shade200.withOpacity(0.5),
              expandedHeight: 120.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('설정', style: TextStyle(color: Colors.black87)),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('계정'),
                    Card(
                      child: Column(
                        children: [
                          // 로그인 상태에 따라 다른 UI를 보여줍니다.
                          if (user != null) ...[
                            _buildSettingsTile(
                              icon: Icons.email_outlined,
                              title: '로그인된 계정',
                              subtitle: user.email, // 사용자 이메일 표시
                              onTap: null, // 탭 비활성화
                            ),
                            _buildSettingsTile(
                              icon: Icons.logout,
                              title: '로그아웃',
                              color: Colors.redAccent,
                              onTap: () => _showLogoutDialog(context),
                            ),
                          ] else ...[
                            _buildSettingsTile(
                              icon: Icons.login,
                              title: '로그인 / 회원가입',
                              subtitle: '게스트로 이용 중입니다.',
                              onTap: () => _goToAuthScreen(context),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('앱 설정'),
                    Card(
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.notifications_outlined,
                            title: '알림 설정',
                            onTap: () {},
                          ),
                          _buildSettingsTile(
                            icon: Icons.palette_outlined,
                            title: '테마 설정',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('정보'),
                    Card(
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.info_outline,
                            title: '앱 버전',
                            subtitle: '1.0.0',
                            onTap: null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.deepPurple),
      title: Text(title,
          style: TextStyle(
              color: color, fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // AuthService().signOut() 호출을 그대로 유지합니다.
      await AuthService().signOut();
    }
  }

  // 게스트일 때 로그인 화면으로 보내는 함수
  void _goToAuthScreen(BuildContext context) async {
    // AuthGate가 상태 변화를 감지하도록 signOut()을 호출합니다.
    await AuthService().signOut();
  }
}
