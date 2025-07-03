import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, User>> getUserByFirstName(String username);
  Future<Either<Failure, User>> getUserByEmailOrId(String? email, int? id);
  Future<Either<Failure, UserModel>> addUser(User user);
  Future<Either<Failure, void>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser();
}

