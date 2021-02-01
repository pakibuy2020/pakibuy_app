import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {}

class LoginSuccess extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
