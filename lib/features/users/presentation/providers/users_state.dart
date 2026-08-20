import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../data/models/user_model.dart';

class UsersState {
  final RequestStatus fetchUsersStatus;
  final PaginationModel<UserModel> usersPagination;

  final RequestStatus createUserStatus;
  final RequestStatus updateUserStatus;
  final RequestStatus toggleBlockStatus;

  final String? errorMessage;

  UsersState({
    this.fetchUsersStatus = RequestStatus.initial,
    PaginationModel<UserModel>? usersPagination,
    this.createUserStatus = RequestStatus.initial,
    this.updateUserStatus = RequestStatus.initial,
    this.toggleBlockStatus = RequestStatus.initial,
    this.errorMessage,
  }) : usersPagination = usersPagination ?? PaginationModel<UserModel>();

  UsersState copyWith({
    RequestStatus? fetchUsersStatus,
    PaginationModel<UserModel>? usersPagination,
    RequestStatus? createUserStatus,
    RequestStatus? updateUserStatus,
    RequestStatus? toggleBlockStatus,
    String? errorMessage,
  }) {
    return UsersState(
      fetchUsersStatus: fetchUsersStatus ?? this.fetchUsersStatus,
      usersPagination: usersPagination ?? this.usersPagination,
      createUserStatus: createUserStatus ?? this.createUserStatus,
      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      toggleBlockStatus: toggleBlockStatus ?? this.toggleBlockStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}