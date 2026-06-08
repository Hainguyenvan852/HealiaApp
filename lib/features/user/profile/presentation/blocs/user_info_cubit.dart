import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/domain/usecases/get_user_info_usecase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState>{
  GetUserInfoUseCase getUserInfoUseCase;
  UserInfoCubit({required this.getUserInfoUseCase}) : super(UserInfoState.initialState());
  
  void loadCurrentUser(UserModel user) async{
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false, user: user));
  }

  void updateUser(String userId) async{
    emit(state.copyWith(isLoading: true));
    final user = await getUserInfoUseCase.call(userId);
    emit(state.copyWith(isLoading: false, user: user));
  }
}