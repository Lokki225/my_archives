part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginClient extends AuthEvent{
  final String email;
  final String password;
  final GlobalKey<FormState> keyform;

  LoginClient(this.email, this.password, this.keyform);
}

final class RegisterClient extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirm;
  final GlobalKey<FormState> keyform;

  RegisterClient(this.firstName,this.lastName,this.email,this.password,this.passwordConfirm,this.keyform);
}

final class LogoutClient extends AuthEvent {}