import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/auth_model.dart';
import 'package:shop_app/modules/splash/splash_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

part 'shop_auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this.dioHelper) : super(AuthInitialState());
  static AuthCubit get(context) => BlocProvider.of(context);
  final DioHelper dioHelper;
  AuthModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AuthLoginLoadingState());
    dioHelper.postData(
      url: lOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) async {
      print(value.data);
      loginModel = AuthModel.fromJson(value.data);
      if (isRemembered) {
        await CacheHelper.sharedPreferences?.setString("email", email);
        await CacheHelper.sharedPreferences?.setString("password", password);
      }
      await CacheHelper.sharedPreferences
          ?.setString("token", loginModel?.data?.token ?? '');
      emit(AuthLoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(
        AuthLoginErrorState(
          error.toString(),
        ),
      );
    });
  }

  static AuthModel? registerModel;
  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(AuthRegisterLoadingState());
    dioHelper.postData(
      url: rEGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      print(value.data);
      registerModel = AuthModel.fromJson(value.data);
      emit(AuthRegisterSuccessState(registerModel!));
    }).catchError((error) {
      print(error.toString());
      emit(
        AuthRegisterErrorState(
          error.toString(),
        ),
      );
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(AuthChangePasswordVisibilityState());
  }

  IconData check = Icons.check_box_outline_blank;
  bool isRemembered = false;
  void changeRememberVisibility() {
    isRemembered = !isRemembered;
    check =
        isRemembered ? Icons.check_box_outlined : Icons.check_box_outline_blank;
    emit(AuthChangeRememberVisibilityState());
  }

  void signOut(context) {
    if (!isRemembered) {
      CacheHelper.sharedPreferences?.remove('email');
      CacheHelper.sharedPreferences?.remove('password');
    }
    CacheHelper.sharedPreferences?.remove('token');
    navigateAndFinish(context, const SplashScreen());
  }
}
