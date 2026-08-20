import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/pagination_action.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/enums/status_filter.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart'; // 🎯 استيراد الحاوية
import '../../../../core/theme/theme/app_constants.dart';

import '../../data/datasources/users_remote_data_source.dart';
import '../../data/models/toggle_user_block_params_model.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/toggle_user_block_status_usecase.dart';
import '../../domain/usecases/get_users_paginated_usecase.dart';
import '../../data/models/user_model.dart';
import 'users_state.dart';

// ====================================================================
// 1. Data Sources & Repositories Providers
// ====================================================================
final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>((ref) {
  return UsersRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final dataSource = ref.watch(usersRemoteDataSourceProvider);
  return UsersRepositoryImpl(dataSource);
});

// ====================================================================
// 2. Use Cases Providers
// ====================================================================
final createUserUseCaseProvider = Provider<CreateUserUseCase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return CreateUserUseCase(repository);
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return UpdateUserUseCase(repository);
});

final toggleUserBlockStatusUseCaseProvider = Provider<ToggleUserBlockStatusUseCase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return ToggleUserBlockStatusUseCase(repository);
});

final getUsersPaginatedUseCaseProvider = Provider<GetUsersPaginatedUseCase>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return GetUsersPaginatedUseCase(repository);
});

// ====================================================================
// 3. State Providers (Search & Filters)
// ====================================================================
final userSearchQueryProvider = StateProvider<String>((ref) => '');
final userCityFilterProvider = StateProvider<String?>((ref) => null);
final userStatusFilterProvider = StateProvider<StatusFilter>((ref) => StatusFilter.all);

// ====================================================================
// 4. UsersNotifier (مركز التحكم النظيف 🧹)
// ====================================================================
class UsersNotifier extends StateNotifier<UsersState> {
  final Ref _ref;
  final int limit = 15;

  UsersNotifier(this._ref) : super(UsersState()) {
    fetchPage(action: PaginationAction.refresh);
  }

  // =========================================================
  // عملية الجلب والفلترة (Boilerplate Pagination)
  // =========================================================
  Future<void> fetchPage({PaginationAction action = PaginationAction.refresh}) async {
    final pagination = state.usersPagination;
    final bool isRefresh = action == PaginationAction.refresh;
    final int newPage = pagination.calculateNewPage(action);

    // 1. تفعيل حالة التحميل وتصفير البيانات إذا كان Refresh
    state = state.copyWith(
      fetchUsersStatus: RequestStatus.loading,
      errorMessage: null,
      usersPagination: isRefresh ? const PaginationModel<UserModel>() : pagination,
    );

    // 2. قراءة الفلاتر الحالية
    final searchQuery = _ref.read(userSearchQueryProvider);
    final cityId = _ref.read(userCityFilterProvider);
    final statusFilter = _ref.read(userStatusFilterProvider);

    // 3. 🎯 تجهيز الحاوية (PaginationParams)
    final params = PaginationParams(
      limit: limit,
      action: action,
      firstDoc: isRefresh ? null : pagination.firstDoc,
      lastDoc: isRefresh ? null : pagination.lastDoc,
    );

    // 4. إرسال الطلب
    final result = await _ref.read(getUsersPaginatedUseCaseProvider).execute(
      paginationParams: params,
      searchQuery: searchQuery,
      cityId: cityId,
      statusFilter: statusFilter,
    );

    // 5. 🎯 معالجة النتيجة بدون أي try-catch واستخدام fold حصراً
    result.fold(
          (failure) {
        state = state.copyWith(
          fetchUsersStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (data) {
        final List<UserModel> newUsers = data[FirestorePaths.users] ?? [];

        state = state.copyWith(
          fetchUsersStatus: RequestStatus.success,
          usersPagination: pagination.copyWith(
            items: newUsers,
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

  void goToNextPage() => fetchPage(action: PaginationAction.next);
  void goToPreviousPage() => fetchPage(action: PaginationAction.previous);
  void refreshWithFilters() => fetchPage(action: PaginationAction.refresh);

  // =========================================================
  // عمليات التعديل والإضافة والحظر (Actions)
  // =========================================================
  Future<void> createUser(UserModel user) async {
    state = state.copyWith(createUserStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(createUserUseCaseProvider).execute(user: user);

    result.fold(
          (failure) => state = state.copyWith(createUserStatus: RequestStatus.error, errorMessage: failure.message),
          (_) {
        state = state.copyWith(createUserStatus: RequestStatus.success);
        refreshWithFilters(); // 🎯 تحديث الجدول فوراً بعد الإضافة
      },
    );
  }

  Future<void> updateUser(UserModel user) async {
    state = state.copyWith(updateUserStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(updateUserUseCaseProvider).execute(user: user);

    result.fold(
          (failure) => state = state.copyWith(updateUserStatus: RequestStatus.error, errorMessage: failure.message),
          (_) {
        state = state.copyWith(updateUserStatus: RequestStatus.success);
        refreshWithFilters();
      },
    );
  }

  Future<void> toggleUserBlockStatus(ToggleUserBlockParams params) async {
    state = state.copyWith(toggleBlockStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(toggleUserBlockStatusUseCaseProvider).execute(params);

    result.fold(
          (failure) => state = state.copyWith(toggleBlockStatus: RequestStatus.error, errorMessage: failure.message),
          (_) {
        state = state.copyWith(toggleBlockStatus: RequestStatus.success);
        refreshWithFilters();
      },
    );
  }
}

// ====================================================================
// 5. Provider النهائي
// ====================================================================
final usersNotifierProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier(ref);
});