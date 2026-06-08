import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'marketplace_setup_state.dart';

class MarketplaceSetupCubit extends Cubit<MarketplaceSetupState> {
  MarketplaceSetupCubit({int? storeId})
    : super(MarketplaceSetupState(storeId: storeId));

  void updateBasicInfo({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) {
    emit(
      state.copyWith(
        storeName: name,
        email: email,
        phone: phone,
        address: address,
      ),
    );
  }

  void updateCoverPhoto(File? photo) {
    emit(
      MarketplaceSetupState(
        storeId: state.storeId,
        storeName: state.storeName,
        email: state.email,
        phone: state.phone,
        address: state.address,
        coverPhoto: photo, // Use this constructor to allow nullifying
        galleryPhotos: state.galleryPhotos,
        description: state.description,
        isLoading: state.isLoading,
        error: state.error,
      ),
    );
  }

  void updateGalleryPhotos(List<File> photos) {
    // Ensure max 9 photos
    final safePhotos = photos.take(9).toList();
    emit(state.copyWith(galleryPhotos: safePhotos));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  Future<void> submitStoreData() async {
    if (state.storeId == null) {
      emit(state.copyWith(error: 'Store ID is missing'));
      return;
    }
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final supabase = Supabase.instance.client;
      final storeId = state.storeId!;
      String? coverPhotoUrl;

      if (state.coverPhoto != null) {
        final ext = state.coverPhoto!.path.split('.').last;
        final fileName = 'cover_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final path = '$storeId/$fileName';
        await supabase.storage
            .from('store images')
            .upload(path, state.coverPhoto!);
        coverPhotoUrl = supabase.storage
            .from('store images')
            .getPublicUrl(path);
      }

      List<String> galleryUrls = [];
      for (int i = 0; i < state.galleryPhotos.length; i++) {
        final photo = state.galleryPhotos[i];
        final ext = photo.path.split('.').last;
        final fileName =
            'gallery_${i}_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final path = '$storeId/$fileName';
        await supabase.storage.from('store images').upload(path, photo);
        final url = supabase.storage.from('store images').getPublicUrl(path);
        galleryUrls.add(url);
      }

      await supabase
          .from('stores')
          .update({
            'is_active': true,
            'name': state.storeName,
            'email': state.email,
            'phone_number': state.phone,
            'address': state.address,
            'introduction': state.description,
            if (coverPhotoUrl != null) 'image_url': coverPhotoUrl,
          })
          .eq('id', storeId);

      for (final url in galleryUrls) {
        await supabase.from('store_images').insert({
          'store_id': storeId,
          'image_url': url,
        });
      }

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
