import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';

class GetTeamMemberByServiceUseCase {
  final StoreRepository repository;

  GetTeamMemberByServiceUseCase(this.repository);

  Future<List<TeamMemberModel>> call(int serviceId){
    return repository.getTeamMemberByService(serviceId);
  }
}