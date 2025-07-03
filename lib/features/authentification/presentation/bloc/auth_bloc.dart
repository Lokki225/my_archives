import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_archives/injection_container.dart';

import '../../../../cubits/app_cubit.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/AddUser.dart';
import '../../domain/usecases/DeleteUser.dart';
import '../../domain/usecases/GetUser.dart';
import '../../domain/usecases/UpdateUser.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUser getUser;
  final AddUser addUser;
  final UpdatedUser updatedUser;
  final DeleteUser deleteUser;

  AuthBloc({
    required this.getUser,
    required this.addUser,
    required this.updatedUser,
    required this.deleteUser,
  }) : super(AuthInitial()) {
    on<LoginClient>(_login);
    on<RegisterClient>(_register);
    on<LogoutClient>(_logout);
  }

  void _login(LoginClient event, Emitter<AuthState> emit) async {
    String password = event.password;
    String email = event.email;

    if (event.keyform.currentState!.validate()) {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        final eitherResult = await getUser.call(email, null);
        await eitherResult.fold(
          (failure) async {
            emit(AuthError("Error during login of User: $email"));
          },
          (userLogged) async {
            if (userLogged.email == email && userLogged.password == password) {
              sL<AppCubit>().changeUserIsConnect(true);
              try {
                await sL<FlutterSecureStorage>().write(
                  key: 'firstName',
                  value: userLogged.firstName,
                );
                final bool isFirstNameSet = await sL<FlutterSecureStorage>()
                    .containsKey(key: 'firstName');
                if (isFirstNameSet) {
                  final String? firstName = await sL<FlutterSecureStorage>()
                      .read(key: 'firstName');
                  if (firstName != null) {
                    emit(AuthSuccess());
                  } else {
                    emit(AuthError("Error during getting first name"));
                  }
                } else {
                  emit(AuthError("Failed to set first name"));
                }
              } catch (e) {
                emit(AuthError("Error during setting first name: $e"));
              }
            } else {
              emit(AuthError("Invalid email or password"));
            }
          },
        );
      } catch (e) {
        emit(AuthError("Unexpected error: $e"));
      }
    } else {
      emit(AuthError("Invalid form input"));
    }
  }


  void _register(RegisterClient event, Emitter<AuthState> emit) async {
    String password = event.password;

    // Create the User object
    final user = User(
      id: 0,
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      username: "${event.firstName} ${event.lastName}",
      profilePicture: "",
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    if (event.keyform.currentState!.validate()) {
      if (password.length > 4) {
        // Emit loading state
        emit(AuthLoading());

        // Simulate a short delay
        await Future.delayed(const Duration(seconds: 2));

        // Add user to database
        final eitherResult = await addUser.call(user);

        await eitherResult.fold(
          (failure) {
            // Emit an error state if adding the user fails
            emit(AuthError("Error occurred during registration: ${failure.toString()}"));
          },
          (userAdded) async {
            try {
              // Login the user after registration
              sL<AppCubit>().changeUserIsConnect(true);

              // Store user data securely
              await sL<FlutterSecureStorage>().write(key: 'firstName', value: userAdded.firstName);
              await sL<FlutterSecureStorage>().write(key: 'email', value: userAdded.email);

              // Verify the data is stored correctly
              final bool isFirstNameSet = await sL<FlutterSecureStorage>().containsKey(key: 'firstName');
              final bool isEmailSet = await sL<FlutterSecureStorage>().containsKey(key: 'email');

              if (isFirstNameSet && isEmailSet) {
                emit(AuthSuccess());
              } else {
                emit(AuthError("Error storing user data locally."));
              }
            } catch (e) {
              emit(AuthError("Error during post-registration process: $e"));
            }
          },
        );
      } else {
        emit(AuthError("Password must be longer than 4 characters."));
      }
    } else {
      emit(AuthError("Invalid form submission."));
    }
  }


  void _logout(LogoutClient event, Emitter<AuthState> emit) async {
    await sL<AppCubit>().deleteUserData();
    print('''
      LocalStorage User firstName: ${await sL<FlutterSecureStorage>().read(key: 'firstName')}}\n
      LocalStorage userIsConnect: ${await sL<FlutterSecureStorage>().read(key: 'userIsConnect')}
    ''');
    emit(AuthLogout());
  }
}
