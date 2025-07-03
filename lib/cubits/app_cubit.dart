import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/core/database/local.dart';
import 'package:my_archives/features/authentification/data/datasources/user_local_datasource.dart';
import 'package:my_archives/features/authentification/data/repositories/user_repository_impl.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentification/domain/repositories/user_repository.dart';
import '../injection_container.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  void initialisationApp()async{
    emit(AppInitial(userConnect: await getUserIsConnect()));
  }

  Future<void> deleteUserData() async{
    await sL<FlutterSecureStorage>().delete(key: "userIsConnect");
    await sL<FlutterSecureStorage>().delete(key: "firstName");
  }

  void changeUserIsConnect(bool value)async{
    await sL<FlutterSecureStorage>().write(key: "userIsConnect", value: value.toString());
  }

  Future<bool> getUserIsConnect()async{
    final String? userIsConnect = await sL<FlutterSecureStorage>().read(key: "userIsConnect");

    if(userIsConnect == null) return false;
    return userIsConnect == "true";
  }

  Future<String?> getUserFirstName() async {
    return await sL<FlutterSecureStorage>().read(key: "firstName");
  }

  Future<void> setUserFirstName(String firstName) async {
    await sL<FlutterSecureStorage>().write(key: "firstName", value: firstName);
  }

  Future<void> setUserPINCode(int id, String pinCode) async {
    await sL<LocalDatabase>().setUserPinCode(id, pinCode);
  }

  Future<int?> getUserIDByFirstName(String firstName) async {
    final User? user = await sL<LocalDatabase>().getUserByFirstName(firstName);

    if(user == null) return null;
    return user.id;
  }

  Future<String> getUserPINCode(int id) async {
    final String? pinCode = await sL<LocalDatabase>().getUserPinCode(id);

    if(pinCode == null) return "Unexpected error while retrieving the user pin_code";
    return pinCode;
  }
}
