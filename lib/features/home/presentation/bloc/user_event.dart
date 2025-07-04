part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class FetchUser extends UserEvent {
  final String firstName;
  FetchUser(this.firstName);
}

final class ChangeUserProfilePictureEvent extends UserEvent {
  final String path;
  final int userId;
  ChangeUserProfilePictureEvent({ required this.path, required this.userId});
}