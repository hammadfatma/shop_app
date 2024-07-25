import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop_layout.dart';
import 'package:shop_app/modules/auth/cubit/shop_auth_cubit.dart';
import 'package:shop_app/modules/auth/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/syles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text =
        CacheHelper.sharedPreferences?.getString("email") ?? '';
    passwordController.text =
        CacheHelper.sharedPreferences?.getString("password") ?? '';
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoginSuccessState) {
          if (state.loginModel.status) {
            showToast(
                text: state.loginModel.message!, state: ToastStates.success);
            navigateAndFinish(context, const ShopLayout());
          } else {
            showToast(
                text: state.loginModel.message!, state: ToastStates.error);
          }
        }
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  backgroundPart(isProfileImage: false, isUpdateImage: false),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Log in to your account',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleBold14.copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: AppStyles.styleRegular14,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            suffix: Icons.cancel_outlined,
                            suffixPressed: () {
                              emailController.clear();
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          const Text(
                            'Password',
                            style: AppStyles.styleRegular14,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: cubit.suffix,
                            isPassword: cubit.isPassword,
                            suffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          rememberPart(
                              check: cubit.check,
                              onTap: () {
                                cubit.changeRememberVisibility();
                              },
                              lastPart: 'Forgot password?'),
                          const SizedBox(
                            height: 22.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AuthLoginLoadingState,
                            builder: (context) {
                              return defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  text: 'Log in');
                            },
                            fallback: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          checkAccount(
                            onTap: () {
                              navigateAndFinish(
                                context,
                                const RegisterScreen(),
                              );
                            },
                            firstPart: 'Don’t have an account?',
                            lastPart: 'Register',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
