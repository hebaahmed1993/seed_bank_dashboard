import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/pagination_action.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/enums/status_filter.dart';
import '../../../../core/models/pagination_model.dart';

import '../../../../core/params/pagination_params.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../../data/datasources/suppliers_remote_data_source.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repositories/suppliers_repository_impl.dart';
import '../../domain/repositories/suppliers_repository.dart';
import '../../domain/usecases/add_supplier_usecase.dart';
import '../../domain/usecases/get_suppliers_usecase.dart';
import '../../domain/usecases/update_supplier_usecase.dart';
import 'suppliers_state.dart';

// ==========================================
// 1. Filter & Search State Providers
// ==========================================
final supplierSearchQueryProvider = StateProvider<String>((ref) => '');
final supplierStatusFilterProvider = StateProvider<StatusFilter>((ref) => StatusFilter.all);

// ==========================================
// 2. Core Providers
// ==========================================
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final suppliersRemoteDataSourceProvider = Provider<SuppliersRemoteDataSource>((ref) {
  return SuppliersRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final suppliersRepositoryProvider = Provider<SuppliersRepository>((ref) {
  return SuppliersRepositoryImpl(ref.watch(suppliersRemoteDataSourceProvider));
});

// ==========================================
// 3. UseCases Providers
// ==========================================
final getSuppliersPaginatedUseCaseProvider = Provider<GetSuppliersPaginatedUseCase>((ref) {
  return GetSuppliersPaginatedUseCase(ref.watch(suppliersRepositoryProvider));
});

final addSupplierUseCaseProvider = Provider<AddSupplierUseCase>((ref) {
  return AddSupplierUseCase(ref.watch(suppliersRepositoryProvider));
});

final updateSupplierUseCaseProvider = Provider<UpdateSupplierUseCase>((ref) {
  return UpdateSupplierUseCase(ref.watch(suppliersRepositoryProvider));
});

// ==========================================
// 4. Notifier (The Clean Version 🧹)
// ==========================================
class SuppliersNotifier extends StateNotifier<SuppliersState> {
  final Ref _ref;
  final int limit = 15;

  SuppliersNotifier(this._ref) : super(SuppliersState()) {
    fetchPage(action: PaginationAction.refresh);
  }


  Future<void> fetchPage({PaginationAction action = PaginationAction.refresh}) async {
    final  pagination = state.pagination;
    final bool isRefresh = action == PaginationAction.refresh;


    final int newPage = pagination.calculateNewPage(action);

    // 2. تحديث حالة التحميل (تصفير البيانات إذا كان بحثاً جديداً أو تحديثاً)
    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
      pagination: isRefresh ? const PaginationModel<SupplierModel>() : pagination,
    );

    // 3. قراءة الفلاتر الحالية
    final searchQuery = _ref.read(supplierSearchQueryProvider);
    final statusFilter = _ref.read(supplierStatusFilterProvider);

    // 4. 🎯 تجهيز حاوية الطلب (التي تعبنا في هندستها!)
    final params = PaginationParams(
      limit: limit,
      action: action,
      // تأمين: نرسل الـ Cursors فقط إذا لم يكن الطلب Refresh
      firstDoc: isRefresh ? null : pagination.firstDoc,
      lastDoc: isRefresh ? null : pagination.lastDoc,
    );

    // 5. إرسال الطلب للسيرفر مباشرة (Single Source of Truth)
    final result = await _ref.read(getSuppliersPaginatedUseCaseProvider).execute(
      paginationParams: params,
      searchQuery: searchQuery,
      isActive: statusFilter.value,
    );

    // 6. التعامل مع النتيجة (Functional Error Handling)
    result.fold(
          (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (data) {
        final List<SupplierModel> newSuppliers = data[FirestorePaths.suppliers] ?? [];

        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          pagination: pagination.copyWith(
            items: newSuppliers,
            firstDoc: data['firstDoc'],
            lastDoc: data['lastDoc'],
            currentPage: newPage,
            hasNextPage: data['hasNextPage'] ?? false,
            hasPreviousPage: newPage > 1,
          ),
        );
      },
    );
  }

  // ----------------------------------------
  // دوال التنقل السريع بين الصفحات
  // ----------------------------------------
  void goToNextPage() => fetchPage(action: PaginationAction.next);
  void goToPreviousPage() => fetchPage(action: PaginationAction.previous);

  // ----------------------------------------
  // إضافة مورد جديد
  // ----------------------------------------
  Future<void> addSupplier(SupplierModel supplier) async {
    state = state.copyWith(addStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(addSupplierUseCaseProvider).execute(supplier);

    result.fold(
          (failure) => state = state.copyWith(
        addStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(addStatus: RequestStatus.success);
        fetchPage(action: PaginationAction.refresh);
      },
    );
  }

  // ----------------------------------------
  // تحديث مورد أو تغيير حالة التفعيل (Switch)
  // ----------------------------------------
  Future<void> updateSupplier(SupplierModel supplier) async {
    state = state.copyWith(updateStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(updateSupplierUseCaseProvider).execute(supplier);

    result.fold(
          (failure) => state = state.copyWith(
        updateStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(updateStatus: RequestStatus.success);
        fetchPage(action: PaginationAction.refresh);
      },
    );
  }
}

// ==========================================
// 5. Provider Export
// ==========================================
final suppliersNotifierProvider = StateNotifierProvider<SuppliersNotifier, SuppliersState>((ref) {
  return SuppliersNotifier(ref);
});