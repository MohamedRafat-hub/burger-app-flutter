import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/cart/data/managers/cart_cubit/cart_cubit.dart';
import 'package:food_app/features/cart/data/managers/get_cart_products_cubit/get_cart_products_cubit.dart';
import 'package:food_app/features/cart/data/models/cart_model.dart';
import 'package:food_app/features/cart/presentation/cart_view.dart';
import 'package:food_app/features/orderHistory/data/managers/getOrders/get_orders_cubit.dart';
import 'package:food_app/features/orderHistory/data/managers/saveOrderCubit/save_order_cubit.dart';
import 'package:food_app/features/product/data/managers/side_option_cubit/side_options_cubit.dart';
import 'package:food_app/features/product/data/managers/topping_cubit/get_toppings_cubit.dart';
import 'package:food_app/features/product/presentation/widgets/display_side_options.dart';
import 'package:food_app/features/product/presentation/widgets/display_toppings.dart';
import 'package:food_app/features/product/presentation/widgets/spicy_slider.dart';
import 'package:food_app/shared/custom_button.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';
import '../../../shared/total_price.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView(
      {super.key,
      required this.image,
      required this.id,
      this.title,
      required this.price});

  final String image;
  final int id;
  final String? title;
  final String price;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = .3;

  DisplayToppings displayToppings = DisplayToppings();
  DisplaySideOptions displaySideOptions = DisplaySideOptions();

  @override
  void initState() {
    context.read<GetToppingsCubit>().getToppings();
    context.read<SideOptionsCubit>().getSideOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => SaveOrderCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Slider
              SpicySlider(
                title: widget.title,
                image: widget.image,
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
              ),
              Gap(50),

              /// Toppings and cards
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CustomText(
                  text: 'Toppings',
                  color: Color(0xFF3C2F2F),
                  fontWeight: FontWeight.w600,
                  size: 18,
                ),
              ),
              Gap(40),

              displayToppings,

              /// Side options and cards
              Gap(40),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CustomText(
                  text: 'Side options',
                  color: Color(0xFF3C2F2F),
                  fontWeight: FontWeight.w600,
                  size: 18,
                ),
              ),
              Gap(40),
              displaySideOptions,
              Gap(40),

              CartButtomSheet(
                price: widget.price,
                cartModel: CartModel(
                    id: widget.id,
                    spicy: value,
                    toppings: displayToppings.selectedToppings,
                    options: displaySideOptions.options),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartButtomSheet extends StatelessWidget {
  const CartButtomSheet(
      {super.key, required this.cartModel, required this.price});

  final CartModel cartModel;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          width: double.infinity,
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartLoading) {
                log('Cart loading...');
              } else if (state is CartSuccess) {
                log('${state.cartModel.cartItems[0].toppings}');
                log('${state.cartModel.cartItems[0].options}');
                log('Cart Success');
                context.read<GetCartProductsCubit>().getCartProducts();
                context.read<GetOrdersCubit>().getOrders();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.primaryColor,
                    content: Text(
                      'Item added successfully ✔ please check your cart',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )));
              } else if (state is CartFailure) {
                log('Cart Failure');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Failure to add item please try again ${state.errorMessage} ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )));
                log('Cart Failure ${state.errorMessage}');
              } else {
                log('No state in Cart');
              }
            },
            builder: (context, state) {
              return Row(
                children: [
                  TotalPrice(
                    price: price,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: (state is CartLoading)
                        ? CupertinoActivityIndicator(
                            radius: 15,
                          )
                        : MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: AppColors.primaryColor,
                            onPressed: () {
                              context.read<CartCubit>().addToCart(
                                  cartModel:
                                      CartRequestModel(cartItems: [cartModel]));
                              context.read<SaveOrderCubit>().saveOrder(
                                  cartModel:
                                      CartRequestModel(cartItems: [cartModel]));
                            },
                            child: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  CupertinoIcons.cart_badge_plus,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
