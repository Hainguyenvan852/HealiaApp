import 'dart:io';
import 'package:equatable/equatable.dart';

class MarketplaceSetupState extends Equatable {
  final int? storeId; // ID of the store to update

  // Step 1: Basic Info
  final String storeName;
  final String email;
  final String phone;
  final String address;

  // Step 2: Photos
  final File? coverPhoto;
  final List<File> galleryPhotos; // max 9

  // Step 2: Description
  final String description;

  // Step 3: Status
  final bool isLoading;
  final String? error;

  const MarketplaceSetupState({
    this.storeId,
    this.storeName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.coverPhoto,
    this.galleryPhotos = const [],
    this.description = '',
    this.isLoading = false,
    this.error,
  });

  MarketplaceSetupState copyWith({
    int? storeId,
    String? storeName,
    String? email,
    String? phone,
    String? address,
    File? coverPhoto,
    List<File>? galleryPhotos,
    String? description,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MarketplaceSetupState(
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      galleryPhotos: galleryPhotos ?? this.galleryPhotos,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // To allow nullifying coverPhoto explicitly if needed, but for now we just overwrite.

  @override
  List<Object?> get props => [
        storeId,
        storeName,
        email,
        phone,
        address,
        coverPhoto,
        galleryPhotos,
        description,
        isLoading,
        error,
      ];
}
