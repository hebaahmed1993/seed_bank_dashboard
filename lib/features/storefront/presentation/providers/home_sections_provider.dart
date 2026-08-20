import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/home_sections_remote_data_source.dart';
import '../../data/models/home_section_model.dart';
import '../../data/repositories/home_sections_repository_impl.dart';
import '../../domain/repositories/home_sections_repository.dart';
import '../../domain/usecases/add_home_section_usecase.dart';
import '../../domain/usecases/delete_home_section_usecase.dart';
import '../../domain/usecases/fetch_home_sections_usecase.dart';
import '../../domain/usecases/update_home_section_usecase.dart';
import 'home_sections_state.dart';

// ==========================================
// 1. Infrastructure Providers
// ==========================================
final homeSectionsDataSourceProvider = Provider<HomeSectionsRemoteDataSource>((ref) {
  return HomeSectionsRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final homeSectionsRepositoryProvider = Provider<HomeSectionsRepository>((ref) {
  return HomeSectionsRepositoryImpl(ref.watch(homeSectionsDataSourceProvider));
});

// ==========================================
// 2. Use Case Providers
// ==========================================
final fetchHomeSectionsUseCaseProvider = Provider<FetchHomeSectionsUseCase>((ref) {
  return FetchHomeSectionsUseCase(ref.watch(homeSectionsRepositoryProvider));
});

final addHomeSectionUseCaseProvider = Provider<AddHomeSectionUseCase>((ref) {
  return AddHomeSectionUseCase(ref.watch(homeSectionsRepositoryProvider));
});

final updateHomeSectionUseCaseProvider = Provider<UpdateHomeSectionUseCase>((ref) {
  return UpdateHomeSectionUseCase(ref.watch(homeSectionsRepositoryProvider));
});

final deleteHomeSectionUseCaseProvider = Provider<DeleteHomeSectionUseCase>((ref) {
  return DeleteHomeSectionUseCase(ref.watch(homeSectionsRepositoryProvider));
});

// ==========================================
// 3. Notifier
// ==========================================
class HomeSectionsNotifier extends StateNotifier<HomeSectionsState> {
  final Ref _ref;

  HomeSectionsNotifier(this._ref) : super(const HomeSectionsState()) {
    fetchSections(); // 🎯 جلب الأقسام مباشرة عند بدء التشغيل
  }

  // ——— Fetch Data ————————————————————————————————
  Future<void> fetchSections() async {
    state = state.copyWith(fetchStatus: RequestStatus.loading, errorMessage: null);

    // 🎯 تم إزالة متغيرات (limit) و (startAfterDoc)
    final result = await _ref.read(fetchHomeSectionsUseCaseProvider).call();

    result.fold(
          (failure) => state = state.copyWith(
        fetchStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (data) {
        // 🎯 جعلناها تدعم حالة إذا كان الـ UseCase يرجع List مباشرة أو Map
        final List<HomeSectionModel> items = data is List<HomeSectionModel>
            ? data
            : List<HomeSectionModel>.from((data as Map)['items'] ?? []);

        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          sections: items,
        );
      },
    );
  }

  // ——— Add ——————————————————————————————————————————————
  Future<void> addSection(HomeSectionModel section) async {
    state = state.copyWith(addStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(addHomeSectionUseCaseProvider).call(section);

    result.fold(
          (failure) => state = state.copyWith(
        addStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(addStatus: RequestStatus.success);
        fetchSections(); // 🎯 تحديث القائمة بعد الإضافة
      },
    );
  }

  // ——— Update ———————————————————————————————————————————
  Future<void> updateSection(HomeSectionModel section) async {
    state = state.copyWith(updateStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(updateHomeSectionUseCaseProvider).call(section);

    result.fold(
          (failure) => state = state.copyWith(
        updateStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(updateStatus: RequestStatus.success);
        fetchSections(); // 🎯 تحديث القائمة بعد التعديل
      },
    );
  }

  // ——— Delete ———————————————————————————————————————————
  Future<void> deleteSection(String sectionId) async {
    state = state.copyWith(deleteStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(deleteHomeSectionUseCaseProvider).call(sectionId);

    result.fold(
          (failure) => state = state.copyWith(
        deleteStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(deleteStatus: RequestStatus.success);
        fetchSections(); // 🎯 تحديث القائمة بعد الحذف
      },
    );
  }

  /// Resets a specific operation status back to initial (e.g., after snackbar shown)
  void resetAddStatus() => state = state.copyWith(addStatus: RequestStatus.initial);
  void resetUpdateStatus() => state = state.copyWith(updateStatus: RequestStatus.initial);
  void resetDeleteStatus() => state = state.copyWith(deleteStatus: RequestStatus.initial);
}

// ==========================================
// 4. Provider Export
// ==========================================
final homeSectionsNotifierProvider = StateNotifierProvider<HomeSectionsNotifier, HomeSectionsState>((ref) {
  return HomeSectionsNotifier(ref);
});