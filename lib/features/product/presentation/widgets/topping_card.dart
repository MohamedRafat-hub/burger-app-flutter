import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/product/data/models/topping_model.dart';
import 'package:gap/gap.dart';

import '../../../../shared/custom_text.dart';

class ToppingCard extends StatelessWidget {
  const ToppingCard(
      {super.key, required this.toppingModel, this.color, this.selected});

  final ToppingModel toppingModel;
  final Color? color;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ///
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF3C2F2F),
              borderRadius: BorderRadius.circular(16),
            ),
            width: 84,
            height: 90,
            child: Column(
              children: [],
            ),
          ),

          ///
          Positioned(
            top: -20,
            left: -5,
            right: -5,
            child: SizedBox(
              height: 70,
              width: 80,
              child: Card(
                color: color ?? Colors.white,
                child: Image.network(
                  toppingModel.secureImageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          /// button
          Positioned(
            left: 6,
            right: 6,
            bottom: 15,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  CustomText(
                    text: toppingModel.name,
                    fontWeight: FontWeight.w500,
                    size: 12,
                    color: Colors.white,
                  ),
                  Spacer(),
                  selected == true
                      ? Icon(
                          CupertinoIcons.check_mark,
                          size: 20,
                          color: Colors.white,
                        )
                      : Image.asset('assets/icons/plus_icon.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
