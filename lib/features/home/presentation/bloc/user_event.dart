part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class FetchUser extends UserEvent {
  final String firstName;
  FetchUser(this.firstName);
}