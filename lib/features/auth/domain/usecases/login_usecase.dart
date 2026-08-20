


import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<UserCredential> call(String email, String password) async {
    // هنا نقوم بطلب تسجيل الدخول مباشرة من المستودع
    return await _repository.loginWithEmailAndPassword(email, password);
  }
}