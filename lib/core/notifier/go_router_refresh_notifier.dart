import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshNotifier extends ChangeNotifier{
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshNotifier(Stream<dynamic> stream){
    _subscription = stream.asBroadcastStream().listen((_){
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}