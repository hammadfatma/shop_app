import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit(this.dioHelper) : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);
  final DioHelper dioHelper;
  SearchModel? model;
  void search(String text) {
    emit(SearchLoadingState());
    dioHelper.postData(
      url: sEARCH,
      token: CacheHelper.sharedPreferences?.getString("token"),
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      emit(SearchErrorState());
    });
  }
}
