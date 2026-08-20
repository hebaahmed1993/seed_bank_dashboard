import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

// --- الـ Dependency Injection (المزودات الخلفية الثابتة) ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

// --- الـ Notifier الحديث (الجيل الجديد من ريفربود للويب) ---
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {

  // دالة الحماية الإبتدائية الإلزامية في الكلاس الجديد
  @override
  AuthState build() {
    return const AuthState(); // الحالة الأولية
  }
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);

      // 1. تسجيل الدخول عبر Firebase Auth
      final userCredential = await loginUseCase(email, password);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        // 2. جلب بيانات المستخدم من جدول users
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          final accountTypeId = userData?['accountTypeId'];

          if (accountTypeId == null || accountTypeId.toString().isEmpty) {
            state = state.copyWith(isLoading: false, errorMessage: 'هذا الحساب غير مرتبطة به صلاحيات.');
            return;
          }

          // 3. جلب نوع الحساب والصلاحيات من جدول accountTypes
          final accountTypeDoc = await FirebaseFirestore.instance.collection('accountTypes').doc(accountTypeId).get();

          if (accountTypeDoc.exists) {
            final typeData = accountTypeDoc.data();
            final permissions = typeData?['permissions'] as List<dynamic>? ?? [];

            // 4. التحقق الديناميكي: هل الصلاحيات تحتوي على 'all' أو أي صلاحية إدارية وليست 'no' أو فارغة؟
            bool hasDashboardAccess = false;

            if (permissions.contains('all')) {
              hasDashboardAccess = true;
            } else if (permissions.isNotEmpty && !permissions.contains('no')) {
              // إذا كان يمتلك صلاحيات مخصصة (مثل products, categories) فيمكنه دخول لوحة التحكم
              hasDashboardAccess = true;
            }

            if (hasDashboardAccess) {
              state = state.copyWith(isLoading: false, isAuthenticated: true);
            } else {
              state = state.copyWith(isLoading: false, errorMessage: 'عذراً، هذا الحساب (مستخدم عادي) غير مصرح له بدخول لوحة التحكم.');
            }
          } else {
            state = state.copyWith(isLoading: false, errorMessage: 'نوع الحساب المرتبط بهذا المستخدم غير موجود في النظام.');
          }
        } else {
          state = state.copyWith(isLoading: false, errorMessage: 'لم يتم العثور على بيانات هذا الحساب في قاعدة البيانات.');
        }
      }
    }

     on FirebaseException catch (e) {
      // 🎯 نجعل الرسالة الافتراضية تعرض الكود الحقيقي لمعرفة المشكلة فوراً
      String errorMsg = 'حدث خطأ: ${e.code}';

      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMsg = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      } else if (e.code == 'network-request-failed') {
        errorMsg = 'يرجى التحقق من اتصالك بالإنترنت.';
      } else if (e.code == 'permission-denied') {
        errorMsg = 'صلاحيات مرفوضة: يرجى التحقق من قواعد أمان Firestore (Security Rules).';
      } else if (e.code == 'too-many-requests') {
        errorMsg = 'تم حظر الحساب مؤقتاً لكثرة المحاولات. جربي لاحقاً.';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}