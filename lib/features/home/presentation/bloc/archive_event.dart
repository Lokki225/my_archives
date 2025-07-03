part of 'archive_bloc.dart';

@immutable
sealed class ArchiveEvent {}

final class FetchArchivesEvent extends ArchiveEvent {
  final SortingOption sortOption;

  FetchArchivesEvent({this.sortOption = SortingOption.all});
}

final class FetchArchiveByIdEvent extends ArchiveEvent {
  final int id;

  FetchArchiveByIdEvent(this.id);
}

final class FetchArchivesByQueryEvent extends ArchiveEvent {
  final String query;

  FetchArchivesByQueryEvent(this.query);
}

final class CreateArchiveEvent extends ArchiveEvent {
  final String title;
  final String description;
  final String coverImage;
  final List<String> resourcePaths;
  final int? folderId;

  CreateArchiveEvent(
      this.title,
      this.description,
      this.coverImage,
      this.resourcePaths,
      this.folderId
  );
}

final class EditArchiveEvent extends ArchiveEvent {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final List<String> resourcePaths;
  final int folderId;

  EditArchiveEvent(
    this.id, this.title,
    this.description,
    this.coverImage,
    this.resourcePaths,
    this.folderId
  );

}

final class DeleteArchiveEvent extends ArchiveEvent {
  final int id;

  DeleteArchiveEvent(this.id);
}

final class ResetArchiveToInitialStateEvent extends ArchiveEvent {}
