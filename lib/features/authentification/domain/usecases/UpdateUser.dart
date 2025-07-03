import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdatedUser {
  final UserRepository repo;

  UpdatedUser({required this.repo});

  Future<Either<Failure, void>> call(User user) async {
    return await repo.updateUser(user);
  }
}