import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/theme/theme/app_constants.dart';
import '../models/account_type_model.dart';
import '../models/staff_model.dart';

abstract class StaffRemoteDataSource {
  Stream<List<StaffModel>> getStaffStream();
  Stream<List<AccountTypeModel>> getAccountTypesStream();
  Future<void> addStaff(StaffModel staff);
  Future<void> updateStaffRole(String staffId, String newRoleId);
  Future<void> toggleStaffBlock(String staffId, bool isBlocked);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final FirebaseFirestore _firestore;

  StaffRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<StaffModel>> getStaffStream() {
    return _firestore
        .collection(FirestorePaths.users)
        .where('accountTypeId', whereIn: ['admin', 'Data_Entry'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StaffModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Stream<List<AccountTypeModel>> getAccountTypesStream() {
    return _firestore.collection(FirestorePaths.accountTypes).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AccountTypeModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> addStaff(StaffModel staff) async {
    FirebaseApp? tempApp;

    try {
      // 1. إنشاء نسخة Firebase فرعية مؤقتة (Temporary Instance)
      // نستخدم Timestamp في الاسم لتجنب أي تعارض إذا تم الضغط مرتين بسرعة
      final tempAppName = 'TempStaffApp_${DateTime.now().millisecondsSinceEpoch}';

      tempApp = await Firebase.initializeApp(
        name: tempAppName,
        options: Firebase.app().options, // ننسخ إعدادات تطبيقنا الرئيسي
      );

      // 2. إنشاء الحساب في Authentication باستخدام النسخة المؤقتة
      final userCredential = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(
        email: staff.email,
        password: staff.password!, // الكلمة التي مررناها من الواجهة
      );

      // 3. أخذ الـ UID الحقيقي الذي تم إنشاؤه للتو
      final String generatedUid = userCredential.user!.uid;

      // 4. تجهيز النموذج الجديد مع الـ UID الصحيح
      final newStaff = staff.copyWith(id: generatedUid);

      // 5. حفظ البيانات في جدول users
      await _firestore
          .collection(FirestorePaths.users)
          .doc(generatedUid)
          .set(newStaff.toFirestore());

    } catch (e) {
      // في حالة حدوث خطأ (مثل الإيميل مستخدم مسبقاً)، نرميه للـ Repository
      throw Exception(e.toString());
    } finally {
      // 6. التنظيف (إلزامي): حذف النسخة المؤقتة لتحرير الذاكرة
      if (tempApp != null) {
        await tempApp.delete();
      }
    }
  }

  @override
  Future<void> updateStaffRole(String staffId, String newRoleId) async {
    await _firestore.collection(FirestorePaths.users).doc(staffId).update({
      'accountTypeId': newRoleId,
    });
  }

  @override
  Future<void> toggleStaffBlock(String staffId, bool isBlocked) async {
    await _firestore.collection(FirestorePaths.users).doc(staffId).update({
      'isBlocked': isBlocked,
    });
  }
}