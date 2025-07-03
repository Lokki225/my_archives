import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/features/archives/domain/usecases/AddNewArchive.dart';
import 'package:my_archives/features/archives/domain/usecases/DeleteArchiveById.dart';
import 'package:my_archives/features/archives/domain/usecases/EditArchiveById.dart';
import 'package:my_archives/features/home/domain/usecases/GetArchives.dart';
import 'package:my_archives/injection_container.dart';

import '../../../../core/constants/constants.dart';
import '../../../../cubits/app_cubit.dart';
import '../../../archives/domain/usecases/GetArchiveById.dart';
import '../../domain/entities/archive_entity.dart';
import '../../domain/usecases/GetArchivesByQuery.dart';
import '../../domain/usecases/GetUserByFirstName.dart';

part 'archive_event.dart';
part 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  final GetArchives getArchives;
  final GetArchivesByQuery getArchivesByQuery;
  final GetArchiveById getArchiveById;
  final GetUserByFirstName getUserByFirstName;
  final AddNewArchive addNewArchive;
  final DeleteArchiveById deleteArchive;
  final EditArchiveById editArchive;

  ArchiveBloc({
    required this.getArchives,
    required this.getArchivesByQuery,
    required this.getArchiveById,
    required this.getUserByFirstName,
    required this.addNewArchive,
    required this.deleteArchive,
    required this.editArchive,
  }) : super(ArchiveInitial()) {
    on<FetchArchivesEvent>(_fetchArchives);
    on<FetchArchivesByQueryEvent>(_fetchArchivesByQuery);
    on<ResetArchiveToInitialStateEvent>(_resetToInitialState);
    on<CreateArchiveEvent>(_createArchive);
    on<EditArchiveEvent>(_editArchive);
    on<DeleteArchiveEvent>(_deleteArchive);
    on<FetchArchiveByIdEvent>(_fetchArchiveById);
  }

  void _fetchArchives(FetchArchivesEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoading());

    final result = await getArchives.call(event.sortOption);
    result.fold(
      (failure) => emit(ArchiveError(error: "Error Loading Archives")),
      (archives) => emit(ArchiveLoaded(archives: archives))
    );
  }

  void _fetchArchiveById(FetchArchiveByIdEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoading());

    final result = await getArchiveById.call(event.id);
    result.fold(
      (failure) => emit(ArchiveError(error: "Error Loading Archive By Id: ${event.id}")),
      (archive) => emit(ArchiveLoaded(archives: [archive]))
    );
  }

  void _fetchArchivesByQuery(FetchArchivesByQueryEvent event, Emitter<ArchiveState> emit) async {
    try {
      emit(ArchiveLoading());
      final result = await getArchivesByQuery.call(event.query);

      result.fold(
        (failure) {
          // print("Failed to fetch archives: $failure");
          emit(ArchiveError(error: "Error Loading Archives"));
        },
        (archives) async{
          try {
            emit(ArchiveLoaded(archives: archives));
            // print("ArchiveLoaded emitted successfully!");
          } catch (e) {
            emit(ArchiveError(error: "Error emitting ArchiveLoaded state $e"));
          }
        },
      );
    } catch (e) {
      emit(ArchiveError(error: "Unexpected error $e occurred"));
    }
  }

  void _resetToInitialState(ResetArchiveToInitialStateEvent event, Emitter<ArchiveState> emit) {
    emit(ArchiveInitial());
  }

  void _createArchive(CreateArchiveEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoading());

    try {
      final userLoggedFirstName = await sL<AppCubit>().getUserFirstName();

      final userResult = await getUserByFirstName.call(userLoggedFirstName!);

      if (emit.isDone) return;

      await userResult.fold(
            (failure) async {
          if (!emit.isDone) emit(ArchiveError(error: "Error Loading User"));
        },
            (user) async {
          final archive = Archive(
            id: 0,
            title: event.title,
            description: event.description,
            coverImage: event.coverImage,
            resourcePaths: event.resourcePaths,
            userId: user.id,
            folderId: event.folderId ?? DEFAULT_FOLDER_ID,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          final result = await addNewArchive.call(archive);

          if (emit.isDone) return;

          result.fold(
                (failure) {
              if (!emit.isDone) emit(ArchiveError(error: "Error Creating Archive"));
            },
                (_) {
              if (!emit.isDone) emit(ArchiveCreated());
            },
          );
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(ArchiveError(error: "Unexpected error: $e"));
    }
  }

  void _editArchive(EditArchiveEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoading());

    try {
      final userLoggedFirstName = await sL<AppCubit>().getUserFirstName();

      final userResult = await getUserByFirstName.call(userLoggedFirstName!);

      await userResult.fold(
            (failure) async {
          emit(ArchiveError(error: "Error Loading User"));
        },
            (user) async {
          final archive = Archive(
            id: event.id,
            title: event.title,
            description: event.description,
            coverImage: event.coverImage,
            resourcePaths: event.resourcePaths,
            userId: user.id,
            folderId: event.folderId,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          final result = await editArchive.call(archive);

          await result.fold(
                (failure) async => emit(ArchiveError(error: "Error Editing Archive")),
                (_) async => emit(ArchiveEdited()),
          );
        },
      );
    } catch (e) {
      emit(ArchiveError(error: "Unexpected error: $e"));
    }
  }

  void _deleteArchive(DeleteArchiveEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoading());

    final result = await deleteArchive.call(event.id);
    result.fold(
      (failure) => emit(ArchiveError(error: "Error Deleting Archive")),
      (_) => emit(ArchiveDeleted())
    );
  }
}
