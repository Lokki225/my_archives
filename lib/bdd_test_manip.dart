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
    // Create a fake user
    final user = User(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'william.henry.harrison@example-pet-store.com',
      password: 'password123',
      username: '',
      profilePicture: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    // Add the user to the local database test
    // await addTestUser(user);

    // Retrieve all users from the local database test
    // final users = await getAllUsers();
    // if (users != null) {
    //   for (final user in users) {
    //     printRetrievedUser(user);
    //   }
    // }

    // Retrieve a specific user by email from the local database test
    // final teddyMail = 'teddydapia15@gmail.com';
    // final retrievedUser = await getUserByEmailOrId(teddyMail, null);
    // if (retrievedUser != null) {
    //   printRetrievedUser(retrievedUser);
    // }

    // final archives = await localDB.getArchives();
    // if (archives != null) {
    //   for (final archive in archives) {
    //     print(archive.toString());
    //   }
    // }

    // final folders = await localDB.getFolders();
    // if (folders != null) {
    //   for (final folder in folders) {
    //     print(folder.toString());
    //   }

    // Edit Archive id: 5
    final archive = Archive(
      id: 5,
      title: 'New Title',
      description: 'New Description',
      coverImage: 'New Cover Image',
      resourcePaths: ['New Resource Path 1', 'New Resource Path 2'],
      userId: 1,
      folderId: 1,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    //
    // print("##############################################################");
    // await localDB.deleteAllArchives();
    // print("##############################################################");

    // final archives = await localDB.getArchives();
    // if (archives != null) {
    //   print('Archives: ${archives.toString()}');
    // }

    // final categories = await localDB.getCategoriesByQuery("na");
    // if (categories != null) {
    //   for (final category in categories) {
    //     print("Category: $category");
    //   }
    // }


  }
  void printRetrievedUser(UserModel retrievedUser) {
      print("##################### TEST LOCAL DB ##########################");
      print('Retrieved User: ${retrievedUser.toString()}');
      print("##############################################################");
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

      // Printing the retrieved user
      printRetrievedUser(retrievedUser);

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


