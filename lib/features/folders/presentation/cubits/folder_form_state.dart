part of 'folder_form_cubit.dart';

@immutable
sealed class FolderFormState {}

final class FolderFormInitial extends FolderFormState {
  static TextEditingController titleController = TextEditingController();
  static TextEditingController coloPickerController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FolderFormInitial();

  static void clearFields (){
    titleController.clear();
    coloPickerController.clear();
  }
}
