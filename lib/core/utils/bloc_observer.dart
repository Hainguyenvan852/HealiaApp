import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver{

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[Bloc Event] ${bloc.runtimeType} => $event');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('[Bloc Event] ${bloc.runtimeType} => $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc,
      Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    log('[Bloc Event] ${bloc.runtimeType} => $transition');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('[Bloc Event] ${bloc.runtimeType} => $change');
  }
}