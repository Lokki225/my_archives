import '../../../../core/database/local.dart';
import '../../../../core/error/exceptions.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';

abstract class UserLocalDataSource {
  /// Throws [CacheException] on error.
  Future<UserModel?> getStoredUser();

  /// Throws [CacheException] on error.
  Future<UserModel?> getUserByFirstName(String? firstName);

  Future<void> addUserProfilePicture(String path, int userId);

  Future<UserModel?> getStoredUserByEmailOrId(String? email, int? id);

  /// Caches a user.
  /// Throws [CacheException] on error.
  Future<UserModel?> cacheUser(UserModel user);

}


class UserLocalDataSourceImpl implements UserLocalDataSource {
  final LocalDatabase localDb;

  UserLocalDataSourceImpl({required this.localDb});

  @override
  Future<UserModel?> cacheUser(UserModel user) async {
    try {
      final userId = await localDb.insertUser(user);
      if (userId == null) {
        throw CacheException();
      }
      final cachedUser = localDb.getUserByEmailOrId(null, userId);
      return cachedUser;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel?> getStoredUser() async {
    try {
      final users = await localDb.getUsers();
      if (users!.isNotEmpty) {
        return users.first;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel?> getStoredUserByEmailOrId(String? email, int? id) async{
    try {
      final user = await localDb.getUserByEmailOrId(email, id);

      if (user != null) {
        return user;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel?> getUserByFirstName(String? firstName) async{
    try {
      if(firstName == null) return null;

      final user = await localDb.getUserByFirstName(firstName);

      if (user != null) {
        return user;
      }
      return null; // Explicitly return null if no data is cached.
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> addUserProfilePicture(String path, int userId) async{
    try {
      await localDb.addUserProfilePicture(path, userId);
    } catch (_) {
      throw CacheException();
    }
  }

}
