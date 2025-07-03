import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'folder_edit_mode_state.dart';

class FolderEditModeCubit extends Cubit<FolderEditModeState> {
  FolderEditModeCubit() : super(FolderEditModeInitial());
  static bool isEditMode = false;

  void enterEditMode() {
    emit(EnterFolderEditMode());
    isEditMode = true;
  }

  void exitEditMode() {
    emit(ExitFolderEditMode());
    isEditMode = false;
  }
}
