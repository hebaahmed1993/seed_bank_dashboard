import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../../../core/enums/status_filter.dart';
import '../../../../core/params/pagination_params.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../models/toggle_user_block_params_model.dart';
import '../models/user_model.dart';
import '../models/activity_log_model.dart';

abstract class UsersRemoteDataSource {
  Future<Map<String, dynamic>> getUsersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? cityId,
    StatusFilter? statusFilter,
  });
  Future<void> createUser({required UserModel userModel});
  Stream<List<UserModel>> getUsersStream();
  Future<void> updateUser({required UserModel userModel});
  Future<void> toggleUserBlockStatus(ToggleUserBlockParams params);
  Future<void> logActivity({required String targetUserId, required ActivityType activityType, required String description});
}



class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsersRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;
  //
  // @override
  // Future<Map<String, dynamic>> getUsersPaginated({
  //   required PaginationParams paginationParams,
  //   String? searchQuery,
  //   String? cityId,
  //   String? statusFilter,
  // }) async {
  //   try {
  //     Query query = _firestore.collection(FirestorePaths.users).where('accountTypeId', isEqualTo: 'user');
  //
  //     // 1. الفلاتر
  //     if (cityId != null && cityId.isNotEmpty) {
  //       query = query.where('cityId', isEqualTo: cityId);
  //     }
  //     if (statusFilter != null && statusFilter != StatusFilter.all) {
  //       // بما أن active تعني isBlocked = false، و inactive تعني isBlocked = true
  //       final bool isBlocked = statusFilter == StatusFilter.inactive;
  //       query = query.where('isBlocked', isEqualTo: isBlocked);
  //     }
  //
  //     // 2. البحث
  //     if (searchQuery != null && searchQuery.trim().isNotEmpty) {
  //       final searchTerm = searchQuery.trim();
  //       final isNumeric = double.tryParse(searchTerm) != null;
  //       final searchField = isNumeric ? 'phone' : 'name';
  //
  //       query = query.orderBy(searchField).startAt([searchTerm]).endAt([searchTerm + '\uf8ff']);
  //     } else {
  //       query = query.orderBy('createdAt', descending: true);
  //     }
  //
  //     // 3. تطبيق نظام الـ Cursors (التقدم والرجوع)
  //     if (paginationParams.action == PaginationAction.next && paginationParams.lastDoc != null) {
  //       query = query.startAfterDocument(paginationParams.lastDoc!).limit(paginationParams.limit);
  //     } else if (paginationParams.action == PaginationAction.previous && paginationParams.firstDoc != null) {
  //       query = query.endBeforeDocument(paginationParams.firstDoc!).limitToLast(paginationParams.limit);
  //     } else {
  //       query = query.limit(paginationParams.limit); // Refresh
  //     }
  //
  //     final QuerySnapshot snapshot = await query.get();
  //     List<UserModel> users = snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       data['uid'] = doc.id;
  //       return UserModel.fromJson(data);
  //     }).toList();
  //
  //     return {
  //       FirestorePaths.users: users, // 🎯 المرجع الموحد
  //       'firstDoc': snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
  //       'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
  //       'hasNextPage': snapshot.docs.length == paginationParams.limit,
  //     };
  //   } catch (e) {
  //     print('🔥 خطأ فايربيز (Users): $e');
  //     throw Exception('فشل جلب المستخدمين: $e');
  //   }
  // }
  //
  //
  //
  //
  //





  @override
  Future<Map<String, dynamic>> getUsersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? cityId,
    StatusFilter? statusFilter, // 🎯 استقبال الـ Enum مباشرة بدلاً من الـ String
  }) async {
    try {
      Query query = _firestore.collection(FirestorePaths.users).where('accountTypeId', isEqualTo: 'user');

      // 1. الفلاتر
      if (cityId != null && cityId.isNotEmpty) {
        query = query.where('cityId', isEqualTo: cityId);
      }

      // 🎯 استخدام الـ value مباشرة من الـ Enum بدون أي مقارنات نصية!
      if (statusFilter != null && statusFilter != StatusFilter.all) {
        query = query.where('isBlocked', isEqualTo: statusFilter.value);
      }

      // 2. البحث
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchTerm = searchQuery.trim();
        final isNumeric = double.tryParse(searchTerm) != null;
        final searchField = isNumeric ? 'phone' : 'name';

        query = query.orderBy(searchField).startAt([searchTerm]).endAt([searchTerm + '\uf8ff']);
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      // 3. تطبيق نظام الـ Cursors
      if (paginationParams.action == PaginationAction.next && paginationParams.lastDoc != null) {
        query = query.startAfterDocument(paginationParams.lastDoc!).limit(paginationParams.limit);
      } else if (paginationParams.action == PaginationAction.previous && paginationParams.firstDoc != null) {
        query = query.endBeforeDocument(paginationParams.firstDoc!).limitToLast(paginationParams.limit);
      } else {
        query = query.limit(paginationParams.limit);
      }

      final QuerySnapshot snapshot = await query.get();
      List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return UserModel.fromJson(data);
      }).toList();

      return {
        FirestorePaths.users: users,
        'firstDoc': snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
        'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        'hasNextPage': snapshot.docs.length == paginationParams.limit,
      };
    } catch (e) {
      print('🔥 خطأ فايربيز (Users): $e');
      throw Exception('فشل جلب المستخدمين: $e');
    }
  }

  @override
  Future<void> createUser({required UserModel userModel}) async {
    try {
      final DocumentReference docRef = _firestore.collection('users').doc();
      final updatedUserModel = userModel.copyWith(uid: docRef.id, createdAt: DateTime.now());
      await docRef.set(updatedUserModel.toJson());
      await logActivity(targetUserId: docRef.id, activityType: ActivityType.userCreate, description: 'إنشاء حساب جديد بالاسم: ${userModel.name}');
    } catch (e) {
      throw Exception('فشل إنشاء الحساب في قاعدة البيانات.');
    }
  }



  @override
  Stream<List<UserModel>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return UserModel.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> updateUser({required UserModel userModel}) async {
    try {
      await _firestore.collection('users').doc(userModel.uid).update(userModel.toJson());
      await logActivity(targetUserId: userModel.uid, activityType: ActivityType.userUpdate, description: 'تحديث بيانات المستخدم: ${userModel.name}');
    } catch (e) {
      throw Exception('فشل تحديث البيانات.');
    }
  }

  @override
  Future<void> toggleUserBlockStatus(ToggleUserBlockParams params) async {
    try {
      await _firestore.collection(FirestorePaths.users).doc(params.userId).update({'isBlocked': params.isBlocked});
    } catch (e) {
      throw Exception('فشل تعديل حالة الحظر.');
    }
  }

  @override
  Future<void> logActivity({required String targetUserId, required ActivityType activityType, required String description}) async {
    try {
      final String adminId = _auth.currentUser?.uid ?? 'unknown_admin';
      final DocumentReference logRef = _firestore.collection('activity_logs').doc();
      final activityLog = ActivityLogModel(id: logRef.id, adminId: adminId, targetUserId: targetUserId, activityTypeId: activityType.value, description: description, timestamp: DateTime.now());
      await logRef.set(activityLog.toJson());
    } catch (e) {
      print('خطأ في تدوين سجلات النشاط: $e');
    }
  }
}