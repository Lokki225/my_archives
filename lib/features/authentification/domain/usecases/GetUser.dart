import 'package:dartz/dartz.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository repo;

  GetUser({required this.repo});

  Future<Either<Failure, User>> call(String? email, int? id) async
  {
    if(email != null) return await repo.getUserByEmailOrId(email, null);
    if(id != null) return await repo.getUserByEmailOrId(null, id);
    return await repo.getUser();
  }

}