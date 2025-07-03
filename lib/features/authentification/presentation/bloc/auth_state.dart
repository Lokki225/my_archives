part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}


final class AuthSuccess extends AuthState {
  AuthSuccess();
}

final class AuthError extends AuthState{
  final String error;
  AuthError(this.error);
}

final class AuthLoading extends AuthState{}

final class AuthLogout extends AuthState{}
