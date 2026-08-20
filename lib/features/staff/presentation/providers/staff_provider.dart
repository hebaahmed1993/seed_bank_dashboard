import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/staff_remote_data_source.dart';
import '../../data/models/account_type_model.dart';
import '../../data/models/staff_model.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../domain/repositories/staff_repository.dart';

// UseCases
import '../../domain/usecases/add_staff_usecase.dart';
import '../../domain/usecases/get_account_types_usecase.dart';
import '../../domain/usecases/get_staff_stream_usecase.dart';
import '../../domain/usecases/toggle_staff_block_usecase.dart';
import '../../domain/usecases/update_staff_role_usecase.dart';

import 'staff_state.dart';

// ==========================================
// 1. Core Providers
// ==========================================
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final staffRemoteDataSourceProvider = Provider<StaffRemoteDataSource>((ref) {
  return StaffRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepositoryImpl(ref.watch(staffRemoteDataSourceProvider));
});

// ==========================================
// 2. UseCases Providers
// ==========================================
final getStaffStreamUseCaseProvider = Provider<GetStaffStreamUseCase>((ref) {
  return GetStaffStreamUseCase(ref.watch(staffRepositoryProvider));
});

final getAccountTypesUseCaseProvider = Provider<GetAccountTypesUseCase>((ref) {
  return GetAccountTypesUseCase(ref.watch(staffRepositoryProvider));
});

final addStaffUseCaseProvider = Provider<AddStaffUseCase>((ref) {
  return AddStaffUseCase(ref.watch(staffRepositoryProvider));
});

final updateStaffRoleUseCaseProvider = Provider<UpdateStaffRoleUseCase>((ref) {
  return UpdateStaffRoleUseCase(ref.watch(staffRepositoryProvider));
});

final toggleStaffBlockUseCaseProvider = Provider<ToggleStaffBlockUseCase>((ref) {
  return ToggleStaffBlockUseCase(ref.watch(staffRepositoryProvider));
});

// ==========================================
// 3. Stream Providers (Live Data)
// ==========================================
final staffStreamProvider = StreamProvider<List<StaffModel>>((ref) {
  return ref.watch(getStaffStreamUseCaseProvider).call();
});

final accountTypesStreamProvider = StreamProvider<List<AccountTypeModel>>((ref) {
  return ref.watch(getAccountTypesUseCaseProvider).call();
});

// ==========================================
// 4. StateNotifier (المتحكم)
// ==========================================
class StaffNotifier extends StateNotifier<StaffState> {
  final AddStaffUseCase _addStaffUseCase;
  final UpdateStaffRoleUseCase _updateStaffRoleUseCase;
  final ToggleStaffBlockUseCase _toggleStaffBlockUseCase;

  StaffNotifier({
    required AddStaffUseCase addStaffUseCase,
    required UpdateStaffRoleUseCase updateStaffRoleUseCase,
    required ToggleStaffBlockUseCase toggleStaffBlockUseCase,
  })  : _addStaffUseCase = addStaffUseCase,
        _updateStaffRoleUseCase = updateStaffRoleUseCase,
        _toggleStaffBlockUseCase = toggleStaffBlockUseCase,
        super(StaffState());

  Future<void> addStaff(StaffModel staff) async {
    state = state.copyWith(addStaffStatus: RequestStatus.loading, errorMessage: null);

    final result = await _addStaffUseCase.call(staff);

    result.fold(
          (failure) => state = state.copyWith(
        addStaffStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(addStaffStatus: RequestStatus.success),
    );
  }

  Future<void> updateStaffRole({required String staffId, required String newRoleId}) async {
    state = state.copyWith(updateStaffRoleStatus: RequestStatus.loading, errorMessage: null);

    final result = await _updateStaffRoleUseCase.call(staffId: staffId, newRoleId: newRoleId);

    result.fold(
          (failure) => state = state.copyWith(
        updateStaffRoleStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateStaffRoleStatus: RequestStatus.success),
    );
  }

  Future<void> toggleStaffBlock({required String staffId, required bool isBlocked}) async {
    state = state.copyWith(toggleStaffBlockStatus: RequestStatus.loading, errorMessage: null);

    final result = await _toggleStaffBlockUseCase.call(staffId: staffId, isBlocked: isBlocked);

    result.fold(
          (failure) => state = state.copyWith(
        toggleStaffBlockStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(toggleStaffBlockStatus: RequestStatus.success),
    );
  }
}

// ==========================================
// 5. Provider للواجهة
// ==========================================
final staffNotifierProvider = StateNotifierProvider<StaffNotifier, StaffState>((ref) {
  return StaffNotifier(
    addStaffUseCase: ref.watch(addStaffUseCaseProvider),
    updateStaffRoleUseCase: ref.watch(updateStaffRoleUseCaseProvider),
    toggleStaffBlockUseCase: ref.watch(toggleStaffBlockUseCaseProvider),
  );
});