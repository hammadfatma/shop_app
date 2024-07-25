import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/search_cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/syles.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(DioHelper(Dio())),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Search product by name',
                      style: AppStyles.styleRegular14,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'enter text to search';
                        }
                        return null;
                      },
                      onSubmit: (text) {
                        SearchCubit.get(context).search(text);
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSuccessState)
                      ConditionalBuilder(
                        condition: SearchCubit.get(context)
                            .model!
                            .data!
                            .data
                            .isNotEmpty,
                        builder: (context) {
                          return Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) => buildListProduct(
                                SearchCubit.get(context)
                                    .model!
                                    .data
                                    ?.data[index],
                                context,
                                isOldPrice: false,
                              ),
                              separatorBuilder: (context, index) => myDivider(),
                              itemCount: SearchCubit.get(context)
                                  .model!
                                  .data!
                                  .data
                                  .length,
                            ),
                          );
                        },
                        fallback: (context) => const Center(
                          child: Column(
                            children: [
                              Text(
                                'Oops!',
                                style: AppStyles.styleBold14,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'No items found',
                                style: AppStyles.styleRegular14,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
