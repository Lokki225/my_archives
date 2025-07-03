import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'folder_form_state.dart';

class FolderFormCubit extends Cubit<FolderFormState> {
  FolderFormCubit() : super(FolderFormInitial());
}
