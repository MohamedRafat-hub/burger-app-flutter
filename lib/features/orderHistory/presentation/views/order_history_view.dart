import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/auth/data/repos/auth_repo.dart';
import 'package:food_app/features/orderHistory/data/models/order_model.dart';
import 'package:food_app/root.dart';
import 'package:food_app/shared/custom_button.dart';

import '../../../../shared/custom_text.dart';
import '../../../auth/presentation/views/signup_view.dart';
import '../../../auth/presentation/views/widgets/custom_material_button.dart';
import '../managers/getOrders/get_orders_cubit.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  void initState() {
    context.read<GetOrdersCubit>().getOrders();
    super.initState();
  }

  List<OrderModel> orders = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<GetOrdersCubit>().getOrders(),
      backgroundColor: Colors.white,
      color: AppColors.primaryColor,
      child: Scaffold(
        body: AuthRepo.isGuest == false
            ? BlocConsumer<GetOrdersCubit, GetOrdersState>(
                listener: (context, state) {
                  if (state is GetOrdersSuccess) {
                    orders = state.orders;
                  }
                },
                builder: (context, state) {
                  return state is GetOrdersLoading
                      ? Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                          ),
                        )
                      : state is GetOrdersSuccess
                          ? orders.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'There is no orders yet',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Request your first order ',
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
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 20),
                                  child: ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 100,
                                                      width: 100,
                                                      imageUrl: orders[index]
                                                          .secureImageUrl,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CustomText(
                                                          text:
                                                              'The date of order is \n ${orders[index].createdAt}',
                                                          size: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          // color: Color(0xFF3C2F2F),
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                        // CustomText(
                                                        //   text: 'Q : x3',
                                                        //   size: 16,
                                                        //   fontWeight: FontWeight.w700,
                                                        //   color: Color(0xFF3C2F2F),
                                                        // ),
                                                        CustomText(
                                                          text:
                                                              'price ${orders[index].totalPrice}\$',
                                                          size: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          // color: Color(0xFF3C2F2F),
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: CustomButton(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(.6),
                                                    buttonName: 'Reorder!',
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return Root();
                                                      }));
                                                    },
                                                    width: double.infinity,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                          : state is GetOrdersFailure
                              ? Center(
                                  child: state.apiError.message ==
                                          'Attempt to read property "id" on null'
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'There is no orders yet',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Request your first order',
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
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
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
                                                    : state.apiError.message,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                              CustomMaterialButton(
                                                buttonName: 'Tap to refresh 🔃',
                                                color: AppColors.primaryColor,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  context
                                                      .read<GetOrdersCubit>()
                                                      .getOrders();
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
                                );
                },
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
  }
}
