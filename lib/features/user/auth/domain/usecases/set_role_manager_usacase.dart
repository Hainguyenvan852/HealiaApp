import 'package:healio_app/features/user/auth/data/datasource/auth_datasource.dart';

class SetRoleManagerUsacase {
  final AuthDataSource dataSource;

  SetRoleManagerUsacase(this.dataSource);

  Future<void> call(String userId) async {
    return await dataSource.setRoleToManager(userId);
  }
}