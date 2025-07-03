part of 'archive_bloc.dart';

@immutable
sealed class ArchiveState {}

final class ArchiveInitial extends ArchiveState {}

final class ArchiveEdited extends ArchiveState {}

final class ArchiveDeleted extends ArchiveState {}

final class ArchiveCreated extends ArchiveState {}

final class ArchiveLoading extends ArchiveState {}

final class ArchiveLoaded extends ArchiveState {
  final List<Archive> archives;

  ArchiveLoaded({required this.archives});
}

final class ArchiveError extends ArchiveState {
  final String error;

  ArchiveError({required this.error});
}
