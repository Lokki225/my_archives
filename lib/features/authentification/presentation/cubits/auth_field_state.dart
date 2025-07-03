part of 'auth_field_cubit.dart';

@immutable
sealed class AuthFieldState {}

final class AuthFieldInitial extends AuthFieldState {
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController passwordConfirmController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthFieldInitial();

  static void clearFields (){
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }
}


final class AuthFieldLogin extends AuthFieldState {
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthFieldLogin();

  static void clearFields (){
    emailController.clear();
    passwordController.clear();
  }
}