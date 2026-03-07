import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/home/data/managers/getProductsCubit/get_products_cubit.dart';
import 'package:food_app/features/home/data/managers/get_categories_cubit/get_categories_cubit.dart';
import 'package:food_app/features/home/data/managers/get_products_by_category/get_products_by_category_cubit.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:food_app/features/home/presentation/widgets/card_item.dart';
import 'package:food_app/features/home/presentation/widgets/home_category.dart';
import 'package:food_app/features/home/presentation/widgets/search_field.dart';
import 'package:food_app/features/home/presentation/widgets/user_header.dart';
import 'package:food_app/features/product/data/managers/side_option_cubit/side_options_cubit.dart';
import 'package:food_app/features/product/data/managers/topping_cubit/get_toppings_cubit.dart';
import 'package:food_app/features/product/presentation/product_details_view.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selected = -1;
  List<ProductModel>? products;
  List<ProductModel>? allProducts;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context.read<GetProductsCubit>().getAllProducts();
    context.read<GetCategoriesCubit>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) => GetProductsByCategoryCubit(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomScrollView(
              slivers: [
                /// Header
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gap(60),
                      UserHeader(),
                      Gap(25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SearchField(
                          controller: controller,
                          onChanged: (value) {
                            final query = value.toLowerCase();
                            setState(() {
                              products = allProducts
                                  ?.where(
                                      (p) => p.name.toLowerCase().contains(query))
                                  .toList();
                            });
                          },
                        ),
                      ),

                      /// Categories
                      Gap(25),
                      BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
                        builder: (context, state) {
                          return state is GetCategoriesSuccess
                              ? BlocListener<GetProductsCubit,
                                  GetProductsState>(
                                  listener: (context, state) {
                                    if (state is GetProductsSuccess) {
                                      log('categories ${state.products.length}');
                                      products = state.products;
                                    }
                                  },
                                  child: HomeCategory(
                                    categories: state.categories,
                                    onCategorySelected: (selectedIndex) {
                                      selected = selectedIndex;
                                      context
                                          .read<GetProductsCubit>()
                                          .getProductsByCategory(
                                              selectedIndex + 1);
                                      log(selectedIndex.toString());
                                    },
                                  ),
                                )
                              : state is GetCategoriesLoading
                                  ? Center(
                                      child: CupertinoActivityIndicator(
                                      radius: 12,
                                    ))
                                  : state is GetCategoriesFailure
                                      ? Center(
                                          child: Text(
                                          '${state.apiError.message}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ))
                                      : Text(
                                          'There was an error Please try again',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        );
                        },
                      ),
                    ],
                  ),
                ),

                /// Products
                BlocConsumer<GetProductsCubit, GetProductsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is GetProductsSuccess) {
                      products = products ?? state.products;
                      allProducts = state.products;
                      log('length is A ${products?.length}');
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: products?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 8,
                              childAspectRatio: .60,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              GetToppingsCubit(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              SideOptionsCubit(),
                                        ),
                                      ],
                                      child: ProductDetailsView(
                                        title: products?[index].desc,
                                        image:
                                            products?[index].secureImageUrl ??
                                                'assets/images/splash.png',
                                        id: products?[index].id ?? 0,
                                        price: products?[index].price ?? '',
                                      ),
                                    );
                                  }));
                                },
                                child: CardItem(
                                  productModel: products?[index],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state is GetProductsLoading) {
                      return SliverFillRemaining(
                          child: Center(
                              child: CupertinoActivityIndicator(
                        radius: 20,
                        color: AppColors.primaryColor,
                      )));
                    } else if (state is GetProductsFailure) {
                      return SliverFillRemaining(
                        child: Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          state.apiError.message,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )),
                      );
                    } else {
                      return SliverFillRemaining(
                        child: Center(
                            child: Text(
                          'No Products for display it',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
