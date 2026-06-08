import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';

class GetTeamMemberByServiceUseCase {
  final StoreRepository repository;

  GetTeamMemberByServiceUseCase(this.repository);

  Future<List<StaffModel>> call(int serviceId) {
    return repository.getTeamMemberByService(serviceId);
  }
}
