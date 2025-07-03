import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_archives/features/authentification/data/models/user_model.dart';
import 'package:my_archives/features/home/domain/usecases/GetUserByFirstName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';
import '../../../authentification/domain/entities/user_entity.dart';
import '../../../authentification/domain/usecases/GetUser.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByFirstName getUserByFirstName;

  UserBloc({
    required this.getUserByFirstName,
  }) : super(UserInitial()) {
    on<FetchUser>(_getLoggedUserData);
  }

  void _getLoggedUserData(FetchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    String firstName = event.firstName;
    await Future.delayed(const Duration(seconds: 2));
    final eitherResult = await getUserByFirstName.call(firstName);
    eitherResult.fold(
      (failure) => emit(UserError("Error during fetching of User: $firstName")),
      (userFetched) async{
        emit(UserLoaded(user: userFetched));
      }
    );
  }
}
