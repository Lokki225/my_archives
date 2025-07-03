import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';
import 'package:my_archives/features/authentification/domain/repositories/user_repository.dart';

class AddUser
{
  final UserRepository repo;

  AddUser({required this.repo});

  Future<Either<Failure, UserModel>> call(User user) async
  {
    return await repo.addUser(user);
  }
}
