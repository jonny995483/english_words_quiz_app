import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 이메일/비밀번호로 회원가입
  Future<User?> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.message}')),
      );
      return null;
    }
  }

  // 이메일/비밀번호로 로그인
  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.message}')),
      );
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
