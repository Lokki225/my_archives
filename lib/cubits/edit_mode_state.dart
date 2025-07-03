part of 'edit_mode_cubit.dart';

@immutable
sealed class EditModeState {}

final class EditModeInitial extends EditModeState {}

final class EnterEditMode extends EditModeState {}

final class ExitEditMode extends EditModeState {}