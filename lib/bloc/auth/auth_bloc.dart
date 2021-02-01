import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mpasabuy/bloc/auth/auth_event.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';

import 'package:mpasabuy/service/auth_service.dart';

class AuthBlock extends Bloc<AuthEvent, AuthState> {
  AuthBlock() : super(Initial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    var service = new AuthService();
    if (event is LoginEvent) {
      yield Loading();
      //login
      await service.login();
      yield Success(service.userData());
    }

    if (event is LogOutEvent) {
      yield Loading();
      await service.logOut();
      yield LogoutSuccess();
    }
  }
}
