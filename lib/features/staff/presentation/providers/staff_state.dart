import '../../../../core/enums/request_status.dart';

class StaffState {
  final RequestStatus addStaffStatus;
  final RequestStatus updateStaffRoleStatus;
  final RequestStatus toggleStaffBlockStatus;
  final String? errorMessage;

  StaffState({
    this.addStaffStatus = RequestStatus.initial,
    this.updateStaffRoleStatus = RequestStatus.initial,
    this.toggleStaffBlockStatus = RequestStatus.initial,
    this.errorMessage,
  });

  StaffState copyWith({
    RequestStatus? addStaffStatus,
    RequestStatus? updateStaffRoleStatus,
    RequestStatus? toggleStaffBlockStatus,
    String? errorMessage,
  }) {
    return StaffState(
      addStaffStatus: addStaffStatus ?? this.addStaffStatus,
      updateStaffRoleStatus: updateStaffRoleStatus ?? this.updateStaffRoleStatus,
      toggleStaffBlockStatus: toggleStaffBlockStatus ?? this.toggleStaffBlockStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}