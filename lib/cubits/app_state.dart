part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {
  final bool?userConnect;
  final String?userName;
  AppInitial({this.userConnect,this.userName});
}


