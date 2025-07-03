part of 'search_field_cubit.dart';

@immutable
sealed class SearchFieldState {}

final class SearchFieldInitial extends SearchFieldState {
  static TextEditingController queryController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SearchFieldInitial();

  static void clearFields (){
    queryController.clear();
  }
}
