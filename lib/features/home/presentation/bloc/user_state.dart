part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserProfilePictureLoaded extends UserState {
  UserProfilePictureLoaded();
}

final class UserLoaded extends UserState {
  final User user;
  UserLoaded({required this.user});
}

final class UserError extends UserState {
  final String error;
  UserError(this.error);
}
