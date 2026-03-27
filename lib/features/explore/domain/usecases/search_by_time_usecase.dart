import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class SearchByTimeUseCase {
  final StoreRepository _storeRepository;

  SearchByTimeUseCase(this._storeRepository);

  Future<List<StoreModel>> call(TimeOfDay startTime, TimeOfDay endTime, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByTime(startTime, endTime, userLat, userLng, radiusKm);
  }
}