import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_setup_state.dart';

class AccountSetupCubit extends Cubit<AccountSetupState> {
  AccountSetupCubit() : super(const AccountSetupState());

  void setBusinessName(String name) {
    emit(state.copyWith(businessName: name));
  }

  void setCategories({required String primary, String? secondary}) {
    emit(
      AccountSetupState(
        businessName: state.businessName,
        primaryCategory: primary,
        secondaryCategory: secondary,
        accountType: state.accountType,
        teamSize: state.teamSize,
        address: state.address,
        lat: state.lat,
        lng: state.lng,
        province: state.province
      ),
    );
  }

  void setAccountType(int type) {
    emit(state.copyWith(accountType: type));
  }

  void setTeamSize(int size) {
    emit(state.copyWith(teamSize: size));
  }

  void setLocation({
    required String address,
    required double lat,
    required double lng,
    required String province
  }) {
    emit(state.copyWith(address: address, lat: lat, lng: lng, province: province));
  }
}
