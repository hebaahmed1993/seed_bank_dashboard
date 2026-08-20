// features/locations/presentation/providers/locations_state.dart

import '../../../../core/enums/request_status.dart';

class LocationsState {
  // حالات المدن
  final RequestStatus addCityStatus;
  final RequestStatus updateCityStatus;

  // حالات المناطق
  final RequestStatus addRegionStatus;
  final RequestStatus updateRegionStatus;

  // رسالة الخطأ المشتركة
  final String? errorMessage;

  LocationsState({
    this.addCityStatus = RequestStatus.initial,
    this.updateCityStatus = RequestStatus.initial,
    this.addRegionStatus = RequestStatus.initial,
    this.updateRegionStatus = RequestStatus.initial,
    this.errorMessage,
  });

  LocationsState copyWith({
    RequestStatus? addCityStatus,
    RequestStatus? updateCityStatus,
    RequestStatus? addRegionStatus,
    RequestStatus? updateRegionStatus,
    String? errorMessage,
  }) {
    return LocationsState(
      addCityStatus: addCityStatus ?? this.addCityStatus,
      updateCityStatus: updateCityStatus ?? this.updateCityStatus,
      addRegionStatus: addRegionStatus ?? this.addRegionStatus,
      updateRegionStatus: updateRegionStatus ?? this.updateRegionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}