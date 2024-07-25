import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/styles/syles.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (bcontext, state) {
        var model = ShopCubit.get(bcontext).userModel;
        nameController.text = model?.data?.name ?? '';
        emailController.text = model?.data?.email ?? '';
        phoneController.text = model?.data?.phone ?? '';
        return Scaffold(
          appBar: AppBar(
            title: const Text('Update Profile'),
          ),
          body: ConditionalBuilder(
            condition: ShopCubit.get(bcontext).userModel != null,
            builder: (context) => Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is ShopLoadingUpdateUserState)
                      const LinearProgressIndicator(),
                    if (state is ShopLoadingUpdateUserState)
                      const SizedBox(
                        height: 10.0,
                      ),
                    backgroundPart(
                      isProfileImage: true,
                      profileImage: model?.data?.image,
                      isUpdateImage: true,
                      updateImage: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('choose what you want'),
                            actions: [
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text('Camera'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ShopCubit.get(bcontext)
                                      .getProfileImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text('Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ShopCubit.get(bcontext)
                                      .getProfileImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state is ShopLoadingUpdateUserState)
                              const LinearProgressIndicator(),
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
                                if (formKey.currentState!.validate()) {
                                  ShopCubit.get(context).updateUserData(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'Save',
                            ),
                            const SizedBox(
                              height: 22.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
