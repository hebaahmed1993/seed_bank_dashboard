import '../../../../core/enums/request_status.dart';
import '../../data/models/home_section_model.dart';

/// Granular state for the Home Sections feature.
/// Each CRUD operation has its own status field so the UI can react
/// independently without clobbering unrelated operations.
class HomeSectionsState {
  final RequestStatus fetchStatus;
  final RequestStatus addStatus;
  final RequestStatus updateStatus;
  final RequestStatus deleteStatus;
  final String? errorMessage;

  // 🎯 تم استبدال PaginationModel بقائمة بسيطة
  final List<HomeSectionModel> sections;

  const HomeSectionsState({
    this.fetchStatus = RequestStatus.initial,
    this.addStatus = RequestStatus.initial,
    this.updateStatus = RequestStatus.initial,
    this.deleteStatus = RequestStatus.initial,
    this.errorMessage,
    this.sections = const [], // 🎯 تهيئة القائمة فارغة
  });

  HomeSectionsState copyWith({
    RequestStatus? fetchStatus,
    RequestStatus? addStatus,
    RequestStatus? updateStatus,
    RequestStatus? deleteStatus,
    String? errorMessage,
    List<HomeSectionModel>? sections,
  }) {
    return HomeSectionsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      addStatus: addStatus ?? this.addStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      // Allow explicitly clearing the error by passing null
      errorMessage: errorMessage,
      sections: sections ?? this.sections,
    );
  }
}