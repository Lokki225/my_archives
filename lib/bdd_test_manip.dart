import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';
import 'core/database/local.dart';
import 'core/error/exceptions.dart';
import 'features/authentification/data/models/user_model.dart';
import 'features/home/domain/entities/archive_entity.dart';


class LocalDBUserTest  {
  final LocalDatabase localDB;


  LocalDBUserTest(
    {required this.localDB}
  );

  void run() async{
    final archives = await localDB.getFolderCategories(1);
    for (final archive in archives) {
      print(archive.toString());
    }
  }

  Future<void> addUserProfilePicture(String path) async {
    try{
      final user = UserModel(
          id: 3,
          firstName: 'Franklin',
          lastName: 'Lokki',
          email: 'franklinlokki@gmail.com',
          password: 'lokki2001',
          username: '',
          profilePicture: path,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch
      );
      // Update the user's profile picture
      await localDB.updateUser(user);
      print('Profile picture updated successfully.');
    }catch(_){
      throw CacheException();
    }

  }

  Future<void> addTestUser(User user) async {
    // Converting User to his Model
    final userToModel = UserModel(
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

    try{
      // Adding User to local DB
      final userId = await localDB.insertUser(userToModel);
      var message = "An Error occurred while getting user ID: $userId";

      // Throw an exception if the userId is null
      if (userId == null) {
        throw AddingIntoLocalDBException(message);
      }

      // Retrieving the user from the local database
      final retrievedUser = await localDB.getUserByEmailOrId(null, userId);
      message = "An Error occurred while retrieving user with ID: $userId";

      // Throw an exception if the retrieved user is null
      if (retrievedUser == null) {
        throw AddingIntoLocalDBException(message);
      }


    }catch (_) {
      print("##############################################################");
      print("A unknown error occurred while adding user with ID: ${user.id}");
      print("##############################################################");
      throw AddingIntoLocalDBException("An Error occurred while adding user with ID: ${user.id}");
    }
  }

  Future<List<UserModel>?> getAllUsers() async {
    try{
      final users = await localDB.getUsers();
      if (users == null) {
        print("##############################################################");
        print("An error occurred while getting users !");
        print("##############################################################");
        throw CacheException();
      }
      return users;
    }catch(_){
      throw CacheException();
    }
  }

  Future<UserModel?> getUserByEmailOrId(String? email, int? id) async {
    try{
      final user = await localDB.getUserByEmailOrId(email, id);
      if (user == null) {
        print("##############################################################");
        print("An error occurred while getting user !");
        print("##############################################################");
        throw CacheException();
      }
      return user;
    }catch(_){
      throw CacheException();
    }
  }
  }


