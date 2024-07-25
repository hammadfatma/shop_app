import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop_layout.dart';
import 'package:shop_app/modules/auth/cubit/shop_auth_cubit.dart';
import 'package:shop_app/modules/auth/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/syles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthRegisterSuccessState) {
          if (state.registerModel.status) {
            showToast(
                text: state.registerModel.message!, state: ToastStates.success);
            navigateAndFinish(context, const ShopLayout());
          } else {
            showToast(
                text: state.registerModel.message!, state: ToastStates.error);
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
                    'Create new account',
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
                            'Username',
                            style: AppStyles.styleRegular14,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            suffix: Icons.cancel_outlined,
                            suffixPressed: () {
                              nameController.clear();
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your user name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
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
                                return 'please enter your email address';
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
                          const Text(
                            'Phone',
                            style: AppStyles.styleRegular14,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            suffix: Icons.cancel_outlined,
                            suffixPressed: () {
                              phoneController.clear();
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your phone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AuthRegisterLoadingState,
                            builder: (context) {
                              return defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userRegister(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text,
                                          phone: phoneController.text);
                                    }
                                  },
                                  text: 'Register');
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
                              navigateAndFinish(context, const LoginScreen());
                            },
                            firstPart: 'Already have an account?',
                            lastPart: 'Log in',
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
