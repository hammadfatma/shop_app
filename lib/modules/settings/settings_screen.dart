import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/auth/cubit/shop_auth_cubit.dart';
import 'package:shop_app/modules/settings/update_profile.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/styles/syles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUserState) {
          ShopCubit.get(context).getUserData();
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model?.data?.name ?? '';
        emailController.text = model?.data?.email ?? '';
        phoneController.text = model?.data?.phone ?? '';
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  backgroundPart(
                      isProfileImage: true,
                      profileImage: model?.data?.image,
                      isUpdateImage: false),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          isClickable: false,
                          controller: nameController,
                          type: TextInputType.name,
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
                          isClickable: false,
                          controller: emailController,
                          type: TextInputType.emailAddress,
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
                          'Phone',
                          style: AppStyles.styleRegular14,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        defaultFormField(
                          isClickable: false,
                          controller: phoneController,
                          type: TextInputType.phone,
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
                        defaultButton(
                          function: () {
                            navigateTo(
                              context,
                              BlocProvider.value(
                                value: BlocProvider.of<ShopCubit>(context),
                                child: const UpdateProfile(),
                              ),
                            );
                          },
                          text: 'Update',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultButton(
                          function: () {
                            AuthCubit.get(context).signOut(context);
                          },
                          text: 'Log out',
                          background: const Color(0xffDC3545),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
