part of 'store_infomation_cubit.dart';

class StoreInfomationState {
  bool isLoading;
  bool? isFavorite;
  Object? error;
  StoreModel? currentStore;
  List<CategoryModel> categories;
  List<StoreWorkingHourModel> workingHours;
  List<ReviewModel> reviews;
  List<StoreModel> nearbyStores;
  List<ImageModel> images;

  StoreInfomationState({
    this.currentStore,
    this.error,
    this.isFavorite,
    required this.isLoading,
    required this.categories,
    required this.workingHours,
    required this.reviews,
    required this.nearbyStores,
    required this.images
  });

  factory StoreInfomationState.initState() => StoreInfomationState(
    categories: [],
    workingHours: [],
    reviews: [], 
    isLoading: false, 
    nearbyStores: [],
    images: []
  );

  StoreInfomationState copyWith({
    bool? isLoading,
    bool? isFavorite,
    StoreModel? store,
    List<CategoryModel>? categories,
    List<StoreWorkingHourModel>? workingHours,
    List<ReviewModel>? reviews,
    Object? error,
    List<StoreModel>? nearbyStores,
    List<ImageModel>? images
  }){
    return StoreInfomationState(
        currentStore: store ?? this.currentStore,
        categories: categories ?? this.categories,
        workingHours: workingHours ?? this.workingHours,
        reviews: reviews ?? this.reviews,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error, 
        nearbyStores: nearbyStores ?? this.nearbyStores,
        isFavorite: isFavorite ?? this.isFavorite, 
        images: images ?? this.images
    );
  }
}
