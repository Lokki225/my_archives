import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'search_field_state.dart';

class SearchFieldCubit extends Cubit<SearchFieldState> {
  SearchFieldCubit() : super(SearchFieldInitial());
}
