import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/styles/syles.dart';

Widget backgroundPart(
        {required bool isProfileImage,
        String? profileImage,
        void Function()? updateImage,
        required bool isUpdateImage}) =>
    Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/images/backgroundFrame.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        Positioned(
          left: 140,
          right: 140,
          bottom: -50,
          child: Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 4.0,
                  color: const Color(0xff000000).withOpacity(0.15),
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.network(
                  profileImage ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcrm_uWMzZaHgVG9ocwMmkuPD7M5egXJHo_4hsP93mobnS2ZnprP9h1lcJiA&s',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
        if (isUpdateImage)
          Positioned(
            top: 140,
            right: 140,
            child: Center(
              child: IconButton(
                onPressed: updateImage,
                icon: const Icon(
                  Icons.edit,
                  size: 32,
                  color: Color(0xff323232),
                ),
              ),
            ),
          ),
      ],
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool isPassword = false,
  bool isClickable = true,
  IconData? suffix,
  void Function()? suffixPressed,
  required String? Function(String?)? validate,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTap,
      enabled: isClickable,
      validator: validate,
      decoration: InputDecoration(
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                  size: 16.0,
                  color: const Color(0xff808194),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          gapPadding: 8.0,
          borderSide: const BorderSide(
            color: Color(0xff808194),
            width: 0.5,
          ),
        ),
      ),
    );
Widget rememberPart(
        {required void Function()? onTap,
        String? lastPart,
        IconData? check,
        BuildContext? context}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                check,
                size: 16,
                color: const Color(0xff808194),
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Text(
                'Remember me',
                style: AppStyles.styleBold14,
              ),
            ],
          ),
        ),
        Text(
          lastPart!,
          textAlign: TextAlign.center,
          style: AppStyles.styleBold14.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: const Color(0xff4F90F0),
            decorationThickness: 1.5,
          ),
        ),
      ],
    );
Widget defaultButton({
  double width = double.infinity,
  Color background = const Color(0xff007BFF),
  double radius = 4.0,
  required void Function()? function,
  required String text,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      width: width,
      height: 44.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppStyles.styleBold14.copyWith(
            color: const Color(0xffFFFFFF),
          ),
        ),
      ),
    );
Widget checkAccount(
        {required void Function()? onTap,
        String? firstPart,
        String? lastPart}) =>
    Row(
      children: [
        Text(
          firstPart!,
          style: AppStyles.styleRegular14.copyWith(
            color: const Color(0xff2A2B2E),
          ),
        ),
        const SizedBox(
          width: 6.0,
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            lastPart!,
            textAlign: TextAlign.center,
            style: AppStyles.styleBold14.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xff4F90F0),
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => false,
  );
}

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? Colors.amber
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
