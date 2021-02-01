import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  Map<String, dynamic> _userData;
  AccessToken _accessToken;
  bool _checking = true;

  Map<String, dynamic> userData() {
    return this._userData;
  }

  Future<void> logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
  }

  Future<void> login() async {
    try {
      _accessToken = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } on FacebookAuthException catch (e) {
      print(e.message); // print the error message in console
      // check the error type
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    } catch (e, s) {
      // print in the logs the unknown errors
      print(e);
      print(s);
    } finally {
      _checking = false;
    }
  }
}
