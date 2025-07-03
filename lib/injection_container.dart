import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:my_archives/core/database/local.dart';
import 'package:my_archives/features/archives/domain/usecases/AddNewArchive.dart';
import 'package:my_archives/features/archives/domain/usecases/DeleteArchiveById.dart';
import 'package:my_archives/features/authentification/data/datasources/user_local_datasource.dart';
import 'package:my_archives/features/authentification/data/repositories/user_repository_impl.dart';
import 'package:my_archives/features/authentification/domain/repositories/user_repository.dart';
import 'package:my_archives/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:my_archives/features/authentification/presentation/cubits/auth_field_cubit.dart';
import 'package:my_archives/features/folders/domain/usecases/AddNewFolder.dart';
import 'package:my_archives/features/home/data/datasources/category_local_datasource.dart';
import 'package:my_archives/features/home/data/repositories/folder_repository_impl.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';
import 'package:my_archives/features/home/domain/usecases/GetCategoriesByQuery.dart';
import 'package:my_archives/features/home/domain/usecases/GetUserByFirstName.dart';
import 'package:my_archives/features/home/presentation/bloc/category_bloc.dart';
import 'package:my_archives/features/home/presentation/bloc/user_bloc.dart';
import 'package:my_archives/features/home/presentation/cubits/search_field_cubit.dart';

import 'cubits/app_cubit.dart';
import 'cubits/edit_mode_cubit.dart';
import 'features/archives/domain/usecases/EditArchiveById.dart';
import 'features/archives/domain/usecases/GetArchiveById.dart';
import 'features/authentification/domain/usecases/AddUser.dart';
import 'features/authentification/domain/usecases/DeleteUser.dart';
import 'features/authentification/domain/usecases/GetUser.dart';
import 'features/authentification/domain/usecases/UpdateUser.dart';
import 'features/categories/domain/usecases/AddNewCategory.dart';
import 'features/categories/domain/usecases/DeleteCategory.dart';
import 'features/categories/domain/usecases/EditCategory.dart';
import 'features/categories/domain/usecases/GetCategories.dart';
import 'features/folders/domain/usecases/DeleFolderById.dart';
import 'features/folders/domain/usecases/EditFolder.dart';
import 'features/folders/domain/usecases/GetRelatedArchives.dart';
import 'features/home/data/datasources/archive_local_datasource.dart';
import 'features/home/data/datasources/folder_local_datasource.dart';
import 'features/home/data/repositories/archive_repository_impl.dart';
import 'features/home/data/repositories/category_repository_impl.dart';
import 'features/home/domain/repositories/archive_repository.dart';
import 'features/home/domain/repositories/category_repository.dart';
import 'features/home/domain/usecases/GetArchives.dart';
import 'features/home/domain/usecases/GetArchivesByQuery.dart';
import 'features/home/domain/usecases/GetFolders.dart';
import 'features/home/domain/usecases/GetFoldersByQuery.dart';
import 'features/home/presentation/bloc/archive_bloc.dart';
import 'features/home/presentation/bloc/folder_bloc.dart';

final sL = GetIt.instance;

Future<void> initializeDep () async{
  // Secure Storage
  sL.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());

  // Local Database
  sL.registerSingleton<LocalDatabase>(LocalDatabase());

  // Dependencies
  sL.registerSingleton<UserLocalDataSource>(UserLocalDataSourceImpl(localDb: sL()));
  sL.registerSingleton<UserRepository>(UserRepositoryImpl(localDataSource: sL()));

  sL.registerSingleton<ArchiveLocalDataSource>(ArchiveLocalDataSourceImpl(localDb: sL()));
  sL.registerSingleton<ArchiveRepository>(ArchiveRepositoryImpl(localDataSource: sL()));

  sL.registerSingleton<FolderLocalDataSource>(FolderLocalDataSourceImpl(localDb: sL()));
  sL.registerSingleton<FolderRepository>(FolderRepositoryImpl(localDataSource: sL()));

  sL.registerSingleton<CategoryLocalDataSource>(CategoryLocalDataSourceImpl(localDb: sL()));
  sL.registerSingleton<CategoryRepository>(CategoryRepositoryImpl(localDataSource: sL()));


  // UseCases
  sL.registerSingleton<GetUser>(GetUser(repo: sL()));
  sL.registerSingleton<AddUser>(AddUser(repo: sL()));
  sL.registerSingleton<UpdatedUser>(UpdatedUser(repo: sL()));
  sL.registerSingleton<DeleteUser>(DeleteUser(repo: sL()));
  sL.registerSingleton<GetUserByFirstName>(GetUserByFirstName(repo: sL()));

  sL.registerSingleton<GetArchives>(GetArchives(repo: sL()));
  sL.registerSingleton<GetArchiveById>(GetArchiveById(repo: sL()));
  sL.registerSingleton<AddNewArchive>(AddNewArchive(repo: sL()));
  sL.registerSingleton<EditArchiveById>(EditArchiveById(repo: sL()));
  sL.registerSingleton<DeleteArchiveById>(DeleteArchiveById(repo: sL()));
  sL.registerSingleton<GetArchivesByQuery>(GetArchivesByQuery(repository: sL()));

  sL.registerSingleton<GetFolders>(GetFolders(repo: sL()));
  sL.registerSingleton<AddNewFolder>(AddNewFolder(repo: sL()));
  sL.registerSingleton<EditFolder>(EditFolder(repo: sL()));
  sL.registerSingleton<DeleteFolderById>(DeleteFolderById(repo: sL()));
  sL.registerSingleton<GetFoldersByQuery>(GetFoldersByQuery(repo: sL()));
  sL.registerSingleton<GetRelatedArchives>(GetRelatedArchives(repo: sL()));

  sL.registerSingleton<GetCategories>(GetCategories(repo: sL()));
  sL.registerSingleton<AddNewCategory>(AddNewCategory(repo: sL()));
  sL.registerSingleton<EditCategory>(EditCategory(repo: sL()));
  sL.registerSingleton<DeleteCategory>(DeleteCategory(repo: sL()));
  sL.registerSingleton<GetCategoriesByQuery>(GetCategoriesByQuery(repo: sL()));


  // Blocks
  sL.registerFactory<AuthBloc>(
      () => AuthBloc(addUser: sL(), getUser: sL(), updatedUser: sL(), deleteUser: sL()),
  );

  sL.registerFactory<UserBloc>(
      () => UserBloc(getUserByFirstName: sL()),
  );

  sL.registerFactory<ArchiveBloc>(
      () => ArchiveBloc(
          getArchives: sL(),
          getArchiveById: sL(),
          getArchivesByQuery: sL(),
          getUserByFirstName: sL(),
          addNewArchive: sL(),
          deleteArchive: sL(),
          editArchive: sL(),
      ),
  );

  sL.registerFactory<FolderBloc>(
      () => FolderBloc(
          getFolders: sL(),
          getFoldersByQuery: sL(),
          addNewFolder: sL(),
          getUserByFirstName: sL(),
          editFolder: sL(),
          deleteFolderById: sL(),
          getRelatedArchives: sL(),
      ),
  );

  sL.registerFactory<CategoryBloc>(
      () => CategoryBloc(
          getUserByFirstName: sL(),
          getCategoriesByQuery: sL(),
          getCategories: sL(),
          addNewCategory: sL(),
          editCategory: sL(),
          deleteCategory: sL(),
      ),
  );

  // Cubits
  sL.registerFactory<AppCubit>(() => AppCubit());
  sL.registerFactory<AuthFieldCubit>(() => AuthFieldCubit());
  sL.registerFactory<AuthFieldLogin>(() => AuthFieldLogin());
  sL.registerFactory<SearchFieldCubit>(() => SearchFieldCubit());
  sL.registerFactory<EditModeCubit>(() => EditModeCubit());
}
