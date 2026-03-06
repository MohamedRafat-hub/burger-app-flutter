import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/auth/data/managers/profile_cubit/profile_cubit.dart';
import 'package:food_app/features/auth/presentation/views/widgets/custom_material_button.dart';
import 'package:food_app/features/cart/data/models/cart_model.dart';
import 'package:food_app/features/checkout/presentation/views/widgets/order_details_widget.dart';
import 'package:food_app/features/home/data/models/product_model.dart';
import 'package:food_app/features/orderHistory/data/managers/saveOrderCubit/save_order_cubit.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:food_app/shared/total_price.dart';
import 'package:gap/gap.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.price, required this.items});

  final double price;
  final List<CartItemModel> items;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfileData();
    super.initState();
  }

  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    log('items length is ${widget.items.length.toString()}');
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderDetailsWidget(
                price: widget.price,
              ),
              CustomText(
                text: 'Payment methods',
                color: Colors.black,
                size: 16,
                fontWeight: FontWeight.w600,
              ),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF3C2F2F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        child: CustomText(
                          text: '\$',
                          fontWeight: FontWeight.bold,
                          size: 20,
                          color: Colors.white,
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      CustomText(
                        text: 'Cash on Delivery',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        size: 16,
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Radio(
                            activeColor: Colors.white,
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return (state is ProfileSuccess &&
                          state.userModel?.visa != null)
                      ? Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/visa.png',
                                  width: 85,
                                ),
                                Column(
                                  children: [
                                    CustomText(
                                      text: 'Debit card',
                                      fontWeight: FontWeight.w500,
                                      size: 14,
                                      color: Color(0xFF3C2F2F),
                                    ),
                                    CustomText(
                                      text: '3566 **** **** 0505',
                                      color: Color(0xFF808080),
                                      fontWeight: FontWeight.w500,
                                      size: 14,
                                    )
                                  ],
                                ),
                                Radio(
                                    activeColor: AppColors.primaryColor,
                                    value: 2,
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    })
                              ],
                            ),
                          ),
                        )
                      : state is ProfileLoading
                          ? Center(
                              child: CupertinoActivityIndicator(
                              radius: 15,
                            ))
                          : SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: Material(
      //   elevation: 10,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(20),
      //         topRight: Radius.circular(20),
      //       ),
      //       color: Colors.white,
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.5),
      //           spreadRadius: 5,
      //           blurRadius: 7,
      //           offset: Offset(0, 3), // changes position of shadow
      //         ),
      //       ],
      //     ),
      //     height: 75,
      //     child: Row(
      //       children: [
      //         TotalPrice(
      //           price: widget.price + 10 + 15,
      //         ),
      //         Spacer(),
      //
      //
      //
      //         Padding(
      //           padding: const EdgeInsets.only(right: 16),
      //           child: MaterialButton(
      //             padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadiusGeometry.circular(12),
      //             ),
      //             color: AppColors.primaryColor,
      //             onPressed: () {
      //               if (selectedValue == 1) {
      //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                     backgroundColor: AppColors.primaryColor,
      //                     content: Center(
      //                         child: Text(
      //                       'Ok delivery man will be receive money cached',
      //                       style: TextStyle(
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.w600,
      //                           color: Colors.white),
      //                     ))));
      //               } else if (selectedValue == 2) {
      //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                     backgroundColor: Colors.green,
      //                     content: Center(
      //                         child: Text(
      //                       'Payment with debit card successfully',
      //                       style: TextStyle(
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.w600,
      //                           color: Colors.white),
      //                     ))));
      //               }
      //             },
      //             child: Text(
      //               'Pay now',
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.w700),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),

      bottomSheet: SizedBox(
          height: 80,
          child: OrderBottomSheet(
            price: widget.price,
            value: selectedValue,
          )),
    );
  }
}

class OrderBottomSheet extends StatelessWidget {
  const OrderBottomSheet({
    super.key,
    required this.price,
    required this.value,
  });

  final double price;
  final int value;

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
          child: Row(
            children: [
              TotalPrice(
                price: price,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppColors.primaryColor,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor:AppColors.primaryColor,
                        content: value == 1
                            ? Text(
                                'Ok the delivery man will receive the money from you.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                'Payment with visa is not allowed',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )));
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        'Pay now',
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
          ),
        ));
  }
}
