part of 'booking_cubit.dart';

class BookingState {
  StoreModel? currentStore;
  List<ServiceModel>? services;
  TeamMemberModel? professional;
  DateTime? date;
  TimeOfDay? startTime;

  BookingState({
    this.services,
    this.startTime,
    this.date,
    this.professional,
    this.currentStore,
  });

  factory BookingState.initialState() => BookingState();

  BookingState copyWith({
    StoreModel? currentStore,
    List<ServiceModel>? services,
    TeamMemberModel? currentProfessional,
    DateTime? date,
    TimeOfDay? startTime,
  }) => BookingState(
    services: services ?? this.services,
    startTime: startTime ?? this.startTime,
    date: date ?? this.date,
    currentStore: currentStore ?? this.currentStore,
    professional: currentProfessional ?? this.professional,
  );

  BookingState clearServices() => BookingState(
    services: null,
    startTime: this.startTime,
    date: this.date,
    currentStore: this.currentStore,
    professional: this.professional,
  );

  BookingState clearProfessional() => BookingState(
    services: this.services,
    startTime: this.startTime,
    date: this.date,
    currentStore: this.currentStore,
    professional: null,
  );

  BookingState clearDateTime() => BookingState(
    services: this.services,
    startTime: null,
    date: null,
    currentStore: this.currentStore,
    professional: this.professional,
  );

  BookingState clearAllExpectStore() => BookingState(
    services: null,
    startTime: null,
    date: null,
    currentStore: this.currentStore,
    professional: null,
  );
}
