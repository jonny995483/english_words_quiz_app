import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- 이 부분이 수정되었습니다 ---
  // 회원가입 메소드 (오류 메시지 개선)
  Future<User?> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
      // Firebase 오류 코드에 따라 사용자에게 보여줄 메시지를 직접 정의합니다.
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다.';
          break;
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다. (6자 이상)';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입 실패: $errorMessage'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return null;
    }
  }

  // --- 이 부분이 수정되었습니다 ---
  // 로그인 메소드 (오류 메시지 개선)
  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
      // Firebase 오류 코드에 따라 사용자에게 보여줄 메시지를 직접 정의합니다.
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = '이메일 또는 비밀번호가 잘못되었습니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'user-disabled':
          errorMessage = '이 계정은 비활성화되었습니다.';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: $errorMessage'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
