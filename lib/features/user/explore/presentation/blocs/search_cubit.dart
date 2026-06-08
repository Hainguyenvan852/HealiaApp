import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/search_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState>{
  SearchFilterCubit() : super(SearchFilterState());

  void updateSearch(SearchFilterState newState){
    emit(newState);
  }

  void clearSearch(){
    emit(SearchFilterState());
  }

  void clearDateTime(SearchFilterState clearState){
    emit(clearState);
  }
}