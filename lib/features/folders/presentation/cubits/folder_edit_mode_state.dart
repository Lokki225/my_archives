part of 'folder_edit_mode_cubit.dart';

@immutable
sealed class FolderEditModeState {}

final class FolderEditModeInitial extends FolderEditModeState {}

final class EnterFolderEditMode extends FolderEditModeState {}

final class ExitFolderEditMode extends FolderEditModeState {}