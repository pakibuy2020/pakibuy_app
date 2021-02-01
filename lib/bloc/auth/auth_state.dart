abstract class AuthState {}

class Initial extends AuthState {}

class Loading extends AuthState {}

class LogoutSuccess extends AuthState {}

class Success extends AuthState {
  Map<String, dynamic> userData;

  Success(Map<String, dynamic> userData) {
    this.userData = userData;
  }

  Map<String, dynamic> getUserData() {
    return this.userData;
  }
}
