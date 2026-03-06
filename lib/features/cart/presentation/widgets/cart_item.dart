import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/shared/custom_button.dart';
import 'package:food_app/shared/custom_text.dart';

import '../../data/models/cart_model.dart';

class CartItem extends StatefulWidget {
  CartItem({super.key, required this.cartItemModel, this.onPressed ,this.child});

  final CartItemModel cartItemModel;
  final void Function()? onPressed;
  final Widget? child;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 100,
                      imageUrl: widget.cartItemModel.secureImageUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // SizedBox(
                    //     height: 100,
                    //     child: Image.network(widget.cartItemModel.image)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: CustomText(
                        text: widget.cartItemModel.name,
                        size: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3C2F2F),
                      ),
                    ),
                    // CustomText(
                    //   text: 'Veggie Burger',
                    //   size: 16,
                    //   fontWeight: FontWeight.w400,
                    //   color: Color(0xFF3C2F2F),
                    // ),
                    CustomText(
                      text: 'Spicy ${widget.cartItemModel.spicy}',
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(quantity>1)
                              {
                                setState(() {
                                  quantity--;
                                });
                              }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.primaryColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Icon(
                              CupertinoIcons.minus_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            // child: SvgPicture.asset(
                            //   'assets/icons/minus_icon.svg',
                            // ),
                          ),
                        ),
                        CustomText(
                          text: quantity.toString(),
                          fontWeight: FontWeight.w700,
                          size: 18,
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.primaryColor,
                            ),
                            // height: 43,
                            //   width: 39,
                            child: Icon(
                              CupertinoIcons.add_circled,
                              color: Colors.white,
                              size: 30,
                            ),
                            // child: SvgPicture.asset('assets/icons/plus_icon.svg'),
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: widget.onPressed,
                      color: AppColors.primaryColor,
                      child: widget.child ?? Text(''),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
