import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_mode_state.dart';

class EditModeCubit extends Cubit<EditModeState> {
  EditModeCubit() : super(EditModeInitial());
  static bool isEditMode = false;

  void enterEditMode() {
    emit(EnterEditMode());
    isEditMode = true;
  }

  void exitEditMode() {
    emit(ExitEditMode());
    isEditMode = false;
  }
}
