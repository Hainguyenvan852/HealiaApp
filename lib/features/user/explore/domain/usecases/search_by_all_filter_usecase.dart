import 'package:flutter/material.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class SearchByAllFilterUseCase {
  final StoreRepository _storeRepository;

  SearchByAllFilterUseCase(this._storeRepository);

  Future<List<StoreModel>> call(String category, TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByAllFilter(category, startTime, endTime, date, userLat, userLng, radiusKm);
  }
}