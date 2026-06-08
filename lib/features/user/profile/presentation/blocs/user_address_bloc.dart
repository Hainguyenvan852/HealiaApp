import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/add_user_address_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/delete_user_address_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/get_user_address_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/update_user_address_usecase.dart';

import '../../data/models/address_model.dart';

part 'user_address_event.dart';
part 'user_address_state.dart';

class UserAddressBloc extends Bloc<UserAddressEvent, UserAddressState>{
  final GetUserAddressUseCase getUserAddressUseCase;
  final AddUserAddressUseCase addAddressUseCase;
  final CheckCurrentUserUseCase checkCurrentUserUseCase;
  final DeleteUserAddressUseCase deleteUserAddressUseCase;
  final UpdateUserAddressUseCase updateUserAddressUseCase;

  UserAddressBloc({
    required this.getUserAddressUseCase,
    required this.addAddressUseCase,
    required this.checkCurrentUserUseCase, required this.deleteUserAddressUseCase, required this.updateUserAddressUseCase
  }) : super(UserAddressState.initial()){

    on<ClearError>((event, emit) async{
      emit(state.copyWith(error: null));
    });

    on<GetUserAddress>((event, emit) async{
      AddressModel? home;
      AddressModel? work;
      List<AddressModel> another = [];

      try {
        emit(state.copyWith(isLoading: true));

        final addresses = await getUserAddressUseCase.call(event.userId);

        for (AddressModel item in addresses){
          if(item.name.toLowerCase() == 'home'){
            home = item;
          } else if(item.name.toLowerCase() == 'work'){
            work = item;
          } else{
            another.add(item);
          }
        }

        emit(state.copyWith(isLoading: false, homeAddress: home, workAddress: work, addresses: another));
      } catch(e){
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<AddUserAddress>((event, emit) async{
      try {
        emit(state.copyWith(isLoading: true));

        await addAddressUseCase.call(event.userId, event.address);

        final addresses = await getUserAddressUseCase.call(event.userId);

        AddressModel? home;
        AddressModel? work;
        List<AddressModel> another = [];

        for (AddressModel item in addresses){
          if(item.name.toLowerCase() == 'home'){
            home = item;
          } else if(item.name.toLowerCase() == 'work'){
            work = item;
          } else{
            another.add(item);
          }
        }

        emit(state.copyWith(isLoading: false, homeAddress: home, workAddress: work, addresses: another));
      } catch(e){
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<DeleteUserAddress>((event, emit) async{
      try {
        emit(state.copyWith(isLoading: true));

        await deleteUserAddressUseCase.call(event.addressId);

        final addresses = await getUserAddressUseCase.call(event.userId);

        AddressModel? home;
        AddressModel? work;
        List<AddressModel> another = [];

        for (AddressModel item in addresses){
          if(item.name.toLowerCase() == 'home'){
            home = item;
          } else if(item.name.toLowerCase() == 'work'){
            work = item;
          } else{
            another.add(item);
          }
        }

        emit(state.update(isLoading: false, homeAddress: home, workAddress: work, addresses: another, error: state.error));
      } catch(e){
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<UpdateUserAddress>((event, emit) async{
      try {
        emit(state.copyWith(isLoading: true));

        await updateUserAddressUseCase.call(event.address);

        final addresses = await getUserAddressUseCase.call(event.userId);

        AddressModel? home;
        AddressModel? work;
        List<AddressModel> another = [];

        for (AddressModel item in addresses){
          if(item.name.toLowerCase() == 'home'){
            home = item;
          } else if(item.name.toLowerCase() == 'work'){
            work = item;
          } else{
            another.add(item);
          }
        }

        emit(state.update(isLoading: false, homeAddress: home, workAddress: work, addresses: another, error: state.error));
      } catch(e){
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<ClearUserAddress>((event, emit) {
      emit(UserAddressState.initial());
    });

    final user = checkCurrentUserUseCase.call();

    if(user != null){
      add(GetUserAddress(userId: user.id));
    }
  }


}