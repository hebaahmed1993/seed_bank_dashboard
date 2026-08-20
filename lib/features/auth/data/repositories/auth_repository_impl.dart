

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    return await _remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.signOut();
  }
}