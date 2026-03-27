import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class SearchStoreAroundLocationUseCase {
  final StoreRepository _storeRepository;

  SearchStoreAroundLocationUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchStoreAroundLocation(userLat, userLng, radiusKm);
  }
}