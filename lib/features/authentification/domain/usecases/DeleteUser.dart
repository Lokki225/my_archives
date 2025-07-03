import 'package:dartz/dartz.dart';
import 'package:my_archives/features/authentification/domain/repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class DeleteUser {
  final UserRepository repo;

  DeleteUser({required this.repo});

  Future<Either<Failure, void>> call() async
  {
    return await repo.deleteUser();
  }
}