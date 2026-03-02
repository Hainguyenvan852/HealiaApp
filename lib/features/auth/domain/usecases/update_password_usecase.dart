import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  Future<UserResponse> call(String newPassword) async {
    return await repository.updatePassword(newPassword);
  }

  UpdatePasswordUseCase(this.repository);
}