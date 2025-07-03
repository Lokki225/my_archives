import 'package:dartz/dartz.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../authentification/domain/repositories/user_repository.dart';

class GetUserByFirstName {
  final UserRepository repo;

  GetUserByFirstName({required this.repo});

  Future<Either<Failure, User>> call(String firstName) async
  {
    return await repo.getUserByFirstName(firstName);
  }

}