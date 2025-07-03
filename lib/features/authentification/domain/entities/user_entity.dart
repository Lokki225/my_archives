import 'package:equatable/equatable.dart';

class User extends Equatable
{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String username;
  final String profilePicture;
  final int createdAt;
  final int updatedAt;

  /*
  final List<Archive> archives;
  final List<Folder> folders;
  final List<Category> categories;*/

  const User({required
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.username,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    /*required this.archives,
    required this.folders,
    required this.categories*/
  });

  @override
  List<Object> get props => [id, firstName, lastName, email, password, username, profilePicture, createdAt, updatedAt];

}
