
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';

class UserModel extends User
{
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.username,
    required super.profilePicture,
    required super.createdAt,
    required super.updatedAt,
});

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    final int createdAt = json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch;
    final int updatedAt = json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch;

    return UserModel(
      id: json['id'] ?? 0, // Use a default value for ID if null
      firstName: json['firstName'] ?? '', // Use an empty string if null
      lastName: json['lastName'] ?? '', // Use an empty string if null
      email: json['email'] ?? '', // Use an empty string if null
      password: json['password'] ?? '', // Use an empty string if null
      username: json['username'] ?? '', // Use an empty string if null
      profilePicture: json['profilePicture'] ?? '', // Use an empty string if null
      createdAt: createdAt, // Default to current timestamp if null
      updatedAt: updatedAt, // Default to current timestamp if null
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'username': username,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
