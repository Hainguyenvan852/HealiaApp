import 'package:flutter/material.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class SearchByDateTimeUseCase {
  final StoreRepository _storeRepository;

  SearchByDateTimeUseCase(this._storeRepository);

  Future<List<StoreModel>> call(TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByDateTime(startTime, endTime, date, userLat, userLng, radiusKm);
  }
}