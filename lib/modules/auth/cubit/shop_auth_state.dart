part of 'shop_auth_cubit.dart';

@immutable
abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoginLoadingState extends AuthStates {}

class AuthLoginSuccessState extends AuthStates {
  final AuthModel loginModel;

  AuthLoginSuccessState(this.loginModel);
}

class AuthLoginErrorState extends AuthStates {
  final String error;

  AuthLoginErrorState(this.error);
}

class AuthChangePasswordVisibilityState extends AuthStates {}

class AuthChangeRememberVisibilityState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {
  final AuthModel registerModel;

  AuthRegisterSuccessState(this.registerModel);
}

class AuthRegisterErrorState extends AuthStates {
  final String error;

  AuthRegisterErrorState(this.error);
}
