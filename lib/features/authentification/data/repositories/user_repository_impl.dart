import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/exceptions.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/authentification/data/datasources/user_local_datasource.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';
import 'package:my_archives/features/authentification/domain/repositories/user_repository.dart';


class UserRepositoryImpl implements UserRepository
{
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserModel>> addUser(User user) async
  {
    try
    {
      final model = UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        password: user.password,
        username: user.username,
        profilePicture: user.profilePicture,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
      final addedUser = await localDataSource.cacheUser(model);
      return Right(addedUser!);
    }
    on CacheException
    {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async
  {
    final updatedList = await localDataSource.getStoredUser();
    try
    {
      await localDataSource.cacheUser(updatedList!);
      return Right(null);
    }
    on CacheException
    {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final user = await localDataSource.getStoredUser();
      if (user != null) {
        return Right(user); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try{
      final model = UserModel(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          password: user.password,
          username: user.username,
          profilePicture: user.profilePicture,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
      );
      localDataSource.cacheUser(model);
      return Right(null);
    }
    on CacheException {
      return Left(CacheFailure());
    }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserByEmailOrId(String? email, int? id) async{
    try {
      final user = await localDataSource.getStoredUserByEmailOrId(email, id);
      if (user != null) {
        return Right(user); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

  @override
  Future<Either<Failure, User>> getUserByFirstName(String firstName) async{
    try {
      final user = await localDataSource.getUserByFirstName(firstName);

      if (user != null) {
        return Right(user); // Return the cached user.
      } else {
        return Left(CacheFailure()); // No user cached.
      }
    } catch (e) {
      return Left(CacheFailure()); // Handle any exceptions.
    }
  }

}
