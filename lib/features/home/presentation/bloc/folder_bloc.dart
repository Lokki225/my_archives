import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/cubits/app_cubit.dart';
import 'package:my_archives/features/folders/domain/usecases/AddNewFolder.dart';
import 'package:my_archives/features/folders/domain/usecases/DeleFolderById.dart';
import 'package:my_archives/features/folders/domain/usecases/GetFolderById.dart';
import 'package:my_archives/features/folders/domain/usecases/GetFolderRelatedCategories.dart';
import 'package:my_archives/features/folders/domain/usecases/GetRelatedArchives.dart';
import 'package:my_archives/features/home/domain/entities/category_entity.dart';
import 'package:my_archives/features/home/domain/entities/folder_entity.dart';
import 'package:my_archives/features/home/domain/usecases/GetFoldersByQuery.dart';
import 'package:my_archives/features/home/domain/usecases/GetUserByFirstName.dart';
import 'package:my_archives/injection_container.dart';

import '../../../folders/domain/usecases/EditFolder.dart';
import '../../domain/entities/archive_entity.dart';
import '../../domain/usecases/GetFolders.dart';

part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final GetFolders getFolders;
  final GetFoldersByQuery getFoldersByQuery;
  final AddNewFolder addNewFolder;
  final EditFolder editFolder;
  final DeleteFolderById deleteFolderById;
  final GetRelatedArchives getRelatedArchives;
  final GetFolderRelatedCategories getFolderRelatedCategories;

  final GetUserByFirstName getUserByFirstName;

  FolderBloc({
    required this.getFolders,
    required this.getFoldersByQuery,
    required this.addNewFolder,
    required this.editFolder,
    required this.deleteFolderById,
    required this.getRelatedArchives,
    required this.getUserByFirstName,
    required this.getFolderRelatedCategories,
}) : super(FolderInitial()) {
    on<FetchFoldersEvent>(_fetchFolderEvent);
    on<FetchFoldersByQueryEvent>(_fetchFoldersByQueryEvent);
    on<ResetFolderToInitialStateEvent>(_resetFolderToInitialStateEvent);
    on<AddNewFolderEvent>(_addNewFolderEvent);
    on<EditFolderEvent>(_editFolderEventHandler);
    on<DeleteFolderEvent>(_deleteFolderEventHandler);
    on<FetchFolderRelatedArchivesAndCategoriesEvent>(_getFolderRelatedArchivesAndCategoriesEventHandler);
  }

  void _fetchFolderEvent(FolderEvent event, Emitter<FolderState> emit) async{
    emit(FolderLoading());
    final result = await getFolders.call();

    try{
      result.fold(
        (failure) => emit(FolderError("Error Loading Folders")),
        (folders) => emit(FolderLoaded(folders))
      );
    }catch(e){
      emit(FolderError("Error Emitting Loaded State"));
    }
  }

  void _fetchFoldersByQueryEvent(FetchFoldersByQueryEvent event, Emitter<FolderState> emit) async {
    emit(FolderLoading());
    final result = await getFoldersByQuery.call(event.query);
    try {
      result.fold(
        (failure) => emit(FolderError("Error Loading Folders")),
        (folders) => emit(FolderLoaded(folders)),
      );
      } catch (e) {
      emit(FolderError("Error Emitting Loaded State $e"));
    }
  }

  void _resetFolderToInitialStateEvent(ResetFolderToInitialStateEvent event, Emitter<FolderState> emit) {
    emit(FolderInitial());
  }

  void _addNewFolderEvent(AddNewFolderEvent event, Emitter<FolderState> emit) async{
    emit(FolderLoading());

    final currentLoggedUserFirstName = await sL<AppCubit>().getUserFirstName();
    if(currentLoggedUserFirstName == null) return;
    final resultUser = await getUserByFirstName.call(currentLoggedUserFirstName);

    resultUser.fold(
      (failure) => emit(FolderError("An error occurred while fetching User: ${event.title}")),
      (user) async{
        final folder = Folder(
          id: 0,
          title: event.title,
          color: event.color,
          userId: user.id,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );

        try{
          final resultFold = await addNewFolder.call(folder);

          resultFold.fold(
            (failure) => emit(FolderError("An error occurred while creating Folder: ${folder.toString()}")),
            (folderId) async{
              print("Folder ID: [$folderId] created successfully!");
              emit(FolderCreated());
            }
          );
        }catch(e){
          emit(FolderError("Error creating new Folder: $e"));
        }
      }
    );
  }

  void _editFolderEventHandler(EditFolderEvent event, Emitter<FolderState> emit) async{
    emit(FolderLoading());

    try{
      final updatedFolder = await editFolder.call(event.id, event.title, event.color);

      updatedFolder.fold(
        (failure) => emit(FolderError("An error occurred while updating Folder: ${event.id}")),
        (_) async{
          print("Folder ID: [${event.id}] updated successfully!");
          emit(FolderEdited());
        }
      );
    }catch(e){
      emit(FolderError("Error editing Folder: $e"));
    }
  }

  void _deleteFolderEventHandler(DeleteFolderEvent event, Emitter<FolderState> emit) async{
    emit(FolderLoading());
    final result = await deleteFolderById.call(event.folderId);

    try{
      result.fold(
        (failure) => emit(FolderError("An error occurred while deleting Folder: ${event.folderId}")),
        (folderId) async{
          print("Folder ID: [${event.folderId}] deleted successfully!");
          emit(FolderDeleted());
        }
      );
    }catch(e){
      emit(FolderError("Error deleting Folder: $e"));
    }
  }

  void _getFolderRelatedArchivesAndCategoriesEventHandler(
      FetchFolderRelatedArchivesAndCategoriesEvent event,
      Emitter<FolderState> emit,
      ) async {
    emit(FolderLoading());

    try {
      final categoryResult = await getFolderRelatedCategories.call(event.folderId);

      if (categoryResult.isLeft()) {
        emit(FolderError("An error occurred while fetching related categories for Folder: ${event.folderId}"));
        return;
      }

      final categories = categoryResult.getOrElse(() => []);

      final archiveResult = await getRelatedArchives.call(event.folderId);

      if (archiveResult.isLeft()) {
        emit(FolderError("An error occurred while fetching related archives for Folder: ${event.folderId}"));
        return;
      }

      final archives = archiveResult.getOrElse(() => []);

      emit(FolderDetailsLoaded(archives: archives, categories: categories));
    } catch (e) {
      emit(FolderError("Unexpected error: $e"));
    }
  }


}
