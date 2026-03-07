import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/auth/presentation/views/signup_view.dart';
import 'package:food_app/features/auth/presentation/views/widgets/custom_material_button.dart';
import 'package:food_app/features/cart/data/managers/get_cart_products_cubit/get_cart_products_cubit.dart';
import 'package:food_app/features/cart/data/managers/remove_item_cubit/remove_item_cubit.dart';
import 'package:food_app/features/cart/data/models/cart_model.dart';
import 'package:food_app/features/checkout/presentation/views/checkout_view.dart';
import 'package:food_app/shared/total_price.dart';

import 'widgets/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int? removingItemId;
  int quantity = 1;
  List<CartItemModel> items = [];

  @override
  void initState() {
    context.read<GetCartProductsCubit>().getCartProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemoveItemCubit(),
      child: BlocListener<RemoveItemCubit, RemoveItemState>(
        listener: (context, state) {
          if (state is RemoveItemLoading) {
            log('Remove Loading...');
          } else if (state is RemoveItemSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.primaryColor,
                content: Text(
                  'Item removed successfully ✔ ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )));
            log('Remove Success');
            removingItemId = null;
            context.read<GetCartProductsCubit>().getCartProducts();
          } else if (state is RemoveItemFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Failure to remove item please try again ${state.apiError.message} ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )));
            log('Remove Failure ... ${state.apiError.message}');
            setState(() {
              removingItemId = null;
            });
          }
        },
        child: BlocConsumer<GetCartProductsCubit, GetCartProductsState>(
          listener: (context, state) {
            if (state is GetCartProductsLoading) {
              log('Loading....');
            } else if (state is GetCartProductsSuccess) {
              items = state.cartItems.items;
              log('Success...');
              log('${state.cartItems.items.length}');
            } else if (state is GetCartProductsFailure) {
              items = [];
              log('Failure...');
              log(state.apiError.toString());
            }
          },
          builder: (context, state) {
            log(AuthRepo.isGuest.toString());
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<GetCartProductsCubit>().getCartProducts(),
              color: AppColors.primaryColor,
              backgroundColor: Colors.white,
              child: Scaffold(
                body: AuthRepo.isGuest == false
                    ? SafeArea(
                        child: state is GetCartProductsLoading
                            ? Center(
                                child: CupertinoActivityIndicator(
                                  radius: 20,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : state is GetCartProductsSuccess
                                ? items.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'There is no products yet',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Add your first product ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Icon(
                                              CupertinoIcons.cart_badge_plus,
                                              color: AppColors.primaryColor,
                                              size: 80,
                                            )
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  state.cartItems.items.length,
                                              itemBuilder: (context, index) {
                                                final item = state
                                                    .cartItems.items[index];

                                                final isLoading =
                                                    removingItemId ==
                                                        item.itemId;
                                                return CartItem(
                                                  onPressed: () {
                                                    setState(() {
                                                      removingItemId =
                                                          item.itemId;
                                                    });

                                                    context
                                                        .read<RemoveItemCubit>()
                                                        .removeItem(
                                                          itemId: item.itemId,
                                                        );
                                                  },
                                                  cartItemModel: item,
                                                  child: isLoading &&
                                                          removingItemId != null
                                                      ? const CupertinoActivityIndicator(
                                                          radius: 15,
                                                          color: Colors.white,
                                                        )
                                                      : const Text(
                                                          'Remove!',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),
                                          ),
                                          Material(
                                            elevation: 10,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, -5),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  TotalPrice(
                                                    price: state
                                                        .cartItems.totalPrice,
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16),
                                                    child: MaterialButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 10),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadiusGeometry
                                                                .circular(12),
                                                      ),
                                                      color: AppColors
                                                          .primaryColor,
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return CheckoutView(
                                                            items: items,
                                                            price: double.parse(
                                                                state.cartItems
                                                                    .totalPrice),
                                                          );
                                                        }));
                                                      },
                                                      child: Text(
                                                        'Checkout',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                : state is GetCartProductsFailure
                                    ? Center(
                                        child: state.apiError.message ==
                                                'Attempt to read property "id" on null'
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'There is no products yet',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Add your first product',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Icon(
                                                    CupertinoIcons
                                                        .cart_badge_plus,
                                                    color: AppColors.primaryColor,
                                                    size: 80,
                                                  )
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Column(
                                                  spacing: 10,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (state.apiError.message ==
                                                              'Too Many Attempts.')
                                                          ? 'Error because many requests'
                                                          : state
                                                              .apiError.message,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.red),
                                                    ),
                                                    CustomMaterialButton(
                                                      buttonName:
                                                          'Tap to refresh 🔃',
                                                      color: AppColors
                                                          .primaryColor,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                GetCartProductsCubit>()
                                                            .getCartProducts();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'Something went wrong please try again',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
                                        ),
                                      ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomMaterialButton(
                            buttonName: 'Go to Signup',
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignupView();
                              }));
                            },
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
