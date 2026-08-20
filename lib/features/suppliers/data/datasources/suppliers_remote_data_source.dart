import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/pagination_action.dart'; // نحتاجه للتحقق من الاتجاه
import '../../../../core/params/pagination_params.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../models/supplier_model.dart';

abstract class SuppliersRemoteDataSource {
  Future<Map<String, dynamic>> getSuppliersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    bool? isActive,
  });
  Future<void> addSupplier(SupplierModel supplier);
  Future<void> updateSupplier(SupplierModel supplier);
  Stream<List<SupplierModel>> getActiveSuppliersStream();
}



class SuppliersRemoteDataSourceImpl implements SuppliersRemoteDataSource {
  final FirebaseFirestore _firestore;

  SuppliersRemoteDataSourceImpl(this._firestore);

  @override
  Future<Map<String, dynamic>> getSuppliersPaginated({
    required PaginationParams paginationParams, // 🎯 1. الحاوية بدلاً من المتغيرات المتفرقة
    String? searchQuery,
    bool? isActive,
  }) async {
    try {
      Query query = _firestore.collection(FirestorePaths.suppliers);
      // 🎯 2. تطبيق فلتر الحالة في الخادم (Firestore)
      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }

      // 🎯 3. الاستعلام الديناميكي للبحث
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchTerm = searchQuery.trim();
        query = query
            .orderBy('companyName')
            .startAt([searchTerm])
            .endAt([searchTerm + '\uf8ff']);
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      // ==========================================
      // 🎯 4. السحر الهندسي: تحديد الاتجاه من الحاوية
      // ==========================================
      if (paginationParams.action == PaginationAction.next && paginationParams.lastDoc != null) {
        // [التالي]: ابدأ بعد آخر مستند واجلب العدد المطلوب
        query = query.startAfterDocument(paginationParams.lastDoc!).limit(paginationParams.limit);

      } else if (paginationParams.action == PaginationAction.previous && paginationParams.firstDoc != null) {
        // [السابق]: قف قبل أول مستند، واجلب العدد المطلوب من الخلف (limitToLast)
        query = query.endBeforeDocument(paginationParams.firstDoc!).limitToLast(paginationParams.limit);

      } else {
        // [Refresh] أو الصفحة الأولى: اجلب العدد المطلوب من البداية
        query = query.limit(paginationParams.limit);
      }

      final QuerySnapshot snapshot = await query.get();
      List<SupplierModel> suppliers = snapshot.docs
          .map((doc) => SupplierModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // ==========================================
      // 🎯 5. إرجاع النتائج والمؤشرات الجديدة
      // ==========================================
      return {
        'suppliers': suppliers,
        'firstDoc': snapshot.docs.isNotEmpty ? snapshot.docs.first : null, // نحتاجه للرجوع
        'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,   // نحتاجه للتقدم
        'hasNextPage': snapshot.docs.length == paginationParams.limit,     // لتفعيل/تعطيل زر التالي
      };
    } catch (e) {
      print('🔥 أوقف كل شيء! هذا هو خطأ فايربيز: $e');
      // طبقة الـ DataSource هي الوحيدة المسموح لها برمي Exceptions كما في القواعد
      throw Exception('فشل جلب الموردين: $e');
    }
  }

  @override
  Future<void> addSupplier(SupplierModel supplier) async {
    try {
      final docRef = _firestore.collection('suppliers').doc();
      final updatedSupplier = supplier.copyWith(id: docRef.id);
      await docRef.set(updatedSupplier.toFirestore());
    } catch (e) {
      throw Exception('فشل إضافة المورد: $e');
    }
  }

  @override
  Future<void> updateSupplier(SupplierModel supplier) async {
    try {
      await _firestore.collection('suppliers').doc(supplier.id).update(supplier.toFirestore());
    } catch (e) {
      throw Exception('فشل تحديث المورد: $e');
    }
  }

  @override
  Stream<List<SupplierModel>> getActiveSuppliersStream() {
    return _firestore
        .collection('suppliers')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SupplierModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }
}