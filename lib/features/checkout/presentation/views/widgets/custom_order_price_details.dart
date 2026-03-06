import 'package:flutter/material.dart';

import '../../../../../shared/custom_text.dart';

class CustomOrderPriceDetails extends StatelessWidget {
  const CustomOrderPriceDetails(
      {super.key, required this.price, required this.title});

  final String price;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: title,
          size: 18,
          fontWeight: FontWeight.w400,
          color: Color(0xFF7D7D7D),
        ),
        Spacer(),
        CustomText(
          text: '\$${price}',
          size: 18,
          fontWeight: FontWeight.w400,
          color: Color(0xFF7D7D7D),
        ),
      ],
    );
  }
}
