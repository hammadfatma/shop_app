import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/auth_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit(this.dioHelper) : super(ShopInitial());
  static ShopCubit get(context) => BlocProvider.of(context);
  final DioHelper dioHelper;
  String? token = CacheHelper.sharedPreferences?.getString("token");
  int currentIndex = 0;
  List<Widget> bottomScreens = const [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    dioHelper.getData(url: hOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel?.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoryModel? categoryModel;
  void getCategories() {
    dioHelper.getData(url: gETCATEGORIES).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    dioHelper
        .postData(
            url: fAVORITES,
            data: {
              'product_id': productId,
            },
            token: token)
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    dioHelper.getData(url: fAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState());
    });
  }

  //// profile
  AuthModel? userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());
    dioHelper
        .getData(
      url: pROFILE,
      token: token,
    )
        .then((value) {
      userModel = AuthModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      emit(ShopErrorUserDataState());
    });
  }

  File? profileImage;
  var picker = ImagePicker();
  var base64Str = '';
  Future<void> getProfileImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(
      source: imageSource,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      List<int> imageBytes = profileImage!.readAsBytesSync();
      base64Str = base64Encode(imageBytes);
      emit(ShopProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      showToast(text: 'No image selected', state: ToastStates.error);
      emit(ShopProfileImagePickedErrorState());
    }
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    dioHelper.putData(
      url: uPDATEPROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'image': base64Str,
      },
    ).then((value) {
      if (value.data['status']) {
        showToast(text: value.data['message'], state: ToastStates.success);
        userModel = AuthModel.fromJson(value.data);
        emit(ShopSuccessUpdateUserState(userModel!));
      } else {
        showToast(text: value.data['message'], state: ToastStates.error);
        emit(ShopErrorUpdateUserState());
      }
    }).catchError((error) {
      emit(ShopErrorUpdateUserState());
    });
  }
}
