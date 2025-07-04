
import 'package:dartz/dartz.dart';
import 'package:my_archives/core/error/failures.dart';
import 'package:my_archives/features/authentification/domain/repositories/user_repository.dart';

class ChangeUserProfilePicture{
  final UserRepository repo;

  ChangeUserProfilePicture({required this.repo});

  Future<Either<Failure, void>> call(String path, int userId) async{
    return await repo.addUserProfilePicture(path, userId);
  }
}