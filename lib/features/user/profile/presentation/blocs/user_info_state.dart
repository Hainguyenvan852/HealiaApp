part of 'user_info_cubit.dart';

class UserInfoState {
  bool isLoading;
  UserModel? user;

  UserInfoState({this.user, required this.isLoading});

  factory UserInfoState.initialState() => UserInfoState(isLoading: false);

  UserInfoState copyWith({
    bool? isLoading,
    UserModel? user
  }) => UserInfoState(
    isLoading: isLoading ?? this.isLoading,
    user: user ?? this.user
  );
}