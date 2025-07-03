import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'auth_field_state.dart';

class AuthFieldCubit extends Cubit<AuthFieldState> {
  AuthFieldCubit() : super(AuthFieldInitial());


}
