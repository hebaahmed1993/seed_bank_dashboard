



import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// دالة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<UserCredential> loginWithEmailAndPassword(String email, String password);


  /// دالة تسجيل الخروج
  Future<void> logout();
}