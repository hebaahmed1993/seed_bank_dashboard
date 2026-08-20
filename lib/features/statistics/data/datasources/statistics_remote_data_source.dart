import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../models/statistics_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<StatisticsModel> getStatistics();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final FirebaseFirestore _firestore;

  StatisticsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(FirestorePaths.products);

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection(FirestorePaths.orders);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestorePaths.users);

  CollectionReference<Map<String, dynamic>> get _suppliers =>
      _firestore.collection(FirestorePaths.suppliers); // مرجع مجموعة الموردين

  @override
  Future<StatisticsModel> getStatistics() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    debugPrint('📊 [StatisticsDataSource] Fetching global & monthly stats...');

    final results = await Future.wait([
      _products.count().get(),                                   // [0] إجمالي المنتجات
      _suppliers.count().get(),                                  // [1] إجمالي الموردين
      _users.where('accountTypeId', isEqualTo: 'user').count().get(), // [2] إجمالي المستخدمين
      _orders.count().get(),                                     // [3] إجمالي الطلبات الكلية
      _orders.where('statusId', isEqualTo: 'processing').count().get(), // [4] الطلبات النشطة حالياً

      // أداء هذا الشهر
      _orders.where('statusId', isEqualTo: 'delivered')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
          .count().get(), // [5] المسلمة هذا الشهر
      _orders.where('statusId', isEqualTo: 'cancelled')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
          .count().get(), // [6] الملغية هذا الشهر
    ]);

    return StatisticsModel(
      totalProducts: results[0].count ?? 0,
      totalSuppliers: results[1].count ?? 0,
      totalUsers: results[2].count ?? 0,
      totalOrders: results[3].count ?? 0,
      activeOrders: results[4].count ?? 0,
      monthlyCompletedOrders: results[5].count ?? 0,
      monthlyCancelledOrders: results[6].count ?? 0,
      monthlyEarnings: 0.0,
      reportMonth: monthStart,
    );
  }
}