import 'package:flutter/material.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

import '../core/constants/app_colors.dart';
import 'custom_button.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key, required this.price
  });

  final dynamic price;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Total',
            color: Color(0xFF3C2F2F),
            fontWeight: FontWeight.w600,
            size: 20,
          ),
          Row(
            children: [
              CustomText(
                text: '\$',
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                size: 20,
              ),
              Gap(5),
              CustomText(
                text: price.toString(),
                color: Color(0xFF3C2F2F),
                fontWeight: FontWeight.w600,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}