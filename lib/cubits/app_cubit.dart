import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/core/database/local.dart';
import 'package:my_archives/features/authentification/data/datasources/user_local_datasource.dart';
import 'package:my_archives/features/authentification/data/repositories/user_repository_impl.dart';
import 'package:my_archives/features/authentification/domain/entities/user_entity.dart';
import 'package:my_archives/features/change_tracker/InsertInTableChangeTracker.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/constants.dart';
import '../core/util/status_to_string.dart';
import '../features/authentification/domain/repositories/user_repository.dart';
import '../features/change_tracker/table_change_tracker_entity.dart';
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

  Future<void> insertTableChange(String tableName, int rowId, TableChangeStatus status, int userId) async{
    final db = sL<LocalDatabase>();
    final String statusString = statusToString(status);
    await db.insertInTrackChange(tableName: tableName, rowId: rowId, status: statusString, userId: userId);
  }

  Future<List<TableChangeTracker>> getTablesChanges(int userId) async{
    final db = sL<LocalDatabase>();
    final tablesChanges = await db.getTablesChanges(userId);
    return tablesChanges;
  }

  Future<List<Category>> getFolderCategories(int folderId) async{
    final db = sL<LocalDatabase>();
    final categories = await db.getFolderCategories(folderId);
    return categories.map((category) => category.toEntity()).toList();
  }
}
